//
//  HMDAPersistentOperation.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 02/11/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import Foundation

@objc public protocol HMDAPersistentOperationObserver {
    @objc func hmdaPersistentOperationDidFail(_ notification: NSNotification)
    @objc func hmdaPersistentOperationDidReceiveInvalidStatusCode(_ notification: NSNotification)
    @objc func hmdaPersistentOperationDidFinish(_ notification: NSNotification)
    @objc func hmdaPersistentOperationDidStart(_ notification: NSNotification)
}

public extension NSNotification.Name {
    static let kHMDAPersistentOperationDidFail = NSNotification.Name(rawValue: "kHMDAPersistentOperationDidFail")
    static let kHMDAPersistentOperationDidReceiveInvalidStatusCode = NSNotification.Name(rawValue: "kHMDAPersistentOperationDidReceiveInvalidStatusCode")
    static let kHMDAPersistentOperationDidFinish = NSNotification.Name(rawValue: "kHMDAPersistentOperationDidFinish")
    static let kHMDAPersistentOperationDidStart = NSNotification.Name(rawValue: "kHMDAPersistentOperationDidStart")
}

@available (iOS 11.0, *)
public class HMDAPersistentOperation: BlockOperation, NSCoding, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    var creationStamp: Date?
    
    private var timeout: TimeInterval = 30.0
    
    private var request: URLRequest?
    
    private var responseData: Data?
    
    private var httpStatusCode: Int = -1
    
    public init(atURL apiURL: URL, withMethod httpMethod: HTTPMethod?, andHeaders headers: HTTPHeaders?, andBodyData bodyData: Data?, andTimeoutInterval interval: TimeInterval?, timestamped: Date) {
        super.init()
        
        creationStamp = timestamped
        
        request = URLRequest(url: apiURL,
                                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                timeoutInterval: interval ?? timeout)
        
        request?.httpMethod = httpMethod?.rawValue ?? HTTPMethod.get.rawValue
        
        request?.httpBody = bodyData
        
        request?.allHTTPHeaderFields = headers        
    }

    override public var description: String {
        
        return """
        URL: \(request?.url?.absoluteString ?? "")
        METHOD: \(request?.httpMethod ?? "GET")
        TIMEOUT: \(request?.timeoutInterval ?? 30.0)
        CREATED: \(creationStamp ?? Date())
        HEADERS:\n\(request?.allHTTPHeaderFields ?? ["":""])
        BODY:\(request?.httpBody?.count ?? 0) bytes
        """
        
    }
    
    // MARK: - URL Session Delegate
    
    private func notificationInfoDict(withHTTPStatus code: Int) -> NotificationUserInfo {
        
        var infoDict = NotificationUserInfo()
        
        infoDict["statusCode"] = code
        
        if let method = request?.httpMethod {
            infoDict["httpMethod"] = method
        }
        
        if let headers = request?.allHTTPHeaderFields {
            infoDict["httpHeaders"] = headers
        }
        
        if let bodyData = request?.httpBody {
            infoDict["httpBody"] = bodyData
        }
        
        return infoDict
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        OSLogDebug("HMDA POP: DID RECEIVE HEADERS: created on: \(creationStamp!)")
        
        // POST notification so that observers can re-schedule the failed operation
        
        httpStatusCode = (response as! HTTPURLResponse).statusCode
        
        if httpStatusCode != 200 {
            NotificationCenter.default.post(name: NSNotification.Name.kHMDAPersistentOperationDidReceiveInvalidStatusCode,
                                            object: self,
                                            userInfo: notificationInfoDict(withHTTPStatus: httpStatusCode))
        }
        
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        OSLogDebug("HMDA POP: WAITING FOR CONNECTIVITY: created on: \(creationStamp!)")
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        OSLogDebug("HMDA POP: DID RECEIVE DATA: created on: \(creationStamp!)")
        
        responseData?.append(data)
    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        willChangeValue(for: \.isExecuting)
        
        urlSessionDataTask?.cancel()
        urlSessionDataTask = nil
        urlSession = nil
        
        didChangeValue(for: \.isExecuting)
        
        NotificationCenter.default.post(name: NSNotification.Name.kHMDAPersistentOperationDidFail,
                                        object: self,
                                        userInfo: notificationInfoDict(withHTTPStatus: httpStatusCode))
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        willChangeValue(for: \.isExecuting)
        willChangeValue(for: \.isFinished)
        
        urlSessionDataTask = nil
        urlSession = nil
        
        responseData = nil
        
        didChangeValue(for: \.isFinished)
        didChangeValue(for: \.isExecuting)
        
        NotificationCenter.default.post(name: NSNotification.Name.kHMDAPersistentOperationDidFinish,
                                        object: self,
                                        userInfo: notificationInfoDict(withHTTPStatus: httpStatusCode))
    }
    
    // MARK: - Operation Queue Implementation Specifics
    
    private var urlSession: URLSession?
    private var urlSessionDataTask: URLSessionDataTask?
    
    private var urlSessionConfig: URLSessionConfiguration {
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        
        return config
    }
    
    public override var isAsynchronous: Bool {
        return false
    }
    
    public override func start() {
        willChangeValue(for: \.isExecuting)
        
        main()
        
        didChangeValue(for: \.isExecuting)
        
        NotificationCenter.default.post(name: NSNotification.Name.kHMDAPersistentOperationDidStart,
                                        object: self,
                                        userInfo: notificationInfoDict(withHTTPStatus: httpStatusCode))
    }
    
    public override var isExecuting: Bool {
        
        guard urlSessionDataTask != nil else {
            return false
        }
     
        if urlSessionDataTask!.state == .running {
            return true
        } else {
            return false
        }
        
    }
    
    public override var isFinished: Bool {
        
        if urlSession != nil {
            return false
        } else {
            return true
        }
        
    }
    
    public override func main() {
        
        guard request != nil else {
            
            willChangeValue(for: \.isFinished)
            didChangeValue(for: \.isFinished)
            
            return
        }
        
        urlSession = URLSession(configuration: urlSessionConfig,
                                 delegate: self,
                                 delegateQueue: nil)
        
        urlSessionDataTask = urlSession?.dataTask(with: request!)
        
        responseData = Data()
        
        urlSessionDataTask?.resume()
    }
    
    // MARK: - NSCoding
    
    public required convenience init?(coder aDecoder: NSCoder) {
        
        if let requestURL = aDecoder.decodeObject(forKey: "requestURL") as? URL {
            var method: HTTPMethod?
            
            if let methodStr = aDecoder.decodeObject(forKey: "httpMethod") as? String {
                method = HTTPMethod(rawValue: methodStr)
            } else {
                method = HTTPMethod.get
            }
            
            let bodyData = aDecoder.decodeObject(forKey: "bodyData") as? Data
            let headers = aDecoder.decodeObject(forKey: "httpHeaders") as? HTTPHeaders
            let timeout = aDecoder.decodeObject(forKey: "timeoutInterval") as? TimeInterval
            let timestamp = aDecoder.decodeObject(forKey: "creationStamp") as? Date
            
            self.init(atURL: requestURL,
                      withMethod: method,
                      andHeaders: headers,
                      andBodyData: bodyData,
                      andTimeoutInterval: timeout,
                      timestamped: timestamp!)
        } else {
            return nil
        }
        
    }

    public func encode(with aCoder: NSCoder) {
        
        guard request != nil else {
            return
        }
        
        aCoder.encode(request!.timeoutInterval, forKey: "timeoutInterval")
        aCoder.encode(creationStamp!, forKey: "creationStamp")
        aCoder.encode(request!.url, forKey: "requestURL")
        aCoder.encode(request!.httpMethod, forKey: "httpMethod")
        aCoder.encode(request!.allHTTPHeaderFields, forKey: "httpHeaders")
        aCoder.encode(request!.httpBody, forKey: "bodyData")
        
    }
    
    // MARK: -  Misc.
    
}
