//
//  HMDAREST.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 21/09/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import Foundation

public enum HMDARestApiError: Error {
    case sessionNotSet
    case requestNotSet
    case httpError(Int)
    case unknownError(Error)
    case invalidJSON
    case unacceptableStatusCode(Int)
    case invalidURLString(String)
}


public class HMDARestApi: NSObject, URLSessionDelegate, URLSessionDataDelegate, URLSessionTaskDelegate {

    static let defaultTimeInterval: TimeInterval = 30
    
    private var validStatusCodeRange: HTTPCodeRange?
    
    private var urlRequest: URLRequest?
    
    var session: URLSession?
    
    var completionHandler: APICompletionHandler?
    var errorHandler: APIErrorHandler?
    var dataHandler: APIDataHandler?
    var uploadHandler: APIUploadHandler?
    
    static public let shared: HMDARestApi = {
        let api = HMDARestApi()
        
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral,
                                 delegate: api,
                                 delegateQueue: nil)
        
        api.session = session
        
        return api
    }()
    
    public convenience init(_ withSession: URLSession) {
        self.init()
        
        session = withSession
    }
    
    public func valid(forStatusCodes codeRange: HTTPCodeRange) -> HMDARestApi {
        validStatusCodeRange = codeRange
        
        return self
    }
    
    public func request(withPath: URL, andMethod: HTTPMethod, andHeaders: HTTPHeaders?) -> HMDARestApi {
        var request = URLRequest(url: withPath)
        
        request.httpMethod = andMethod.rawValue
        request.allHTTPHeaderFields = andHeaders
        
        urlRequest = request
        
        return self
    }
    
    public func dataRequest(_ successHandler: @escaping APISuccessHandler, _ errorHandler: @escaping APIErrorHandler) throws {
        
        guard session != nil else {
            throw HMDARestApiError.sessionNotSet
        }
        
        guard urlRequest != nil else {
            throw HMDARestApiError.requestNotSet
        }
        
        let task = session!.dataTask(with: urlRequest!) { (data, response, error) in
            let httpStatusCode = ((response as? HTTPURLResponse)?.statusCode)!
            
            if error != nil {
                
                DispatchQueue.main.async {
                    errorHandler(HMDARestApiError.unknownError(error!))
                }
                
            } else {
                
                if self.validStatusCodeRange == nil {
                    
                    DispatchQueue.main.async {
                        successHandler(data)
                    }
                    
                } else {
                    
                    if self.validStatusCodeRange!.contains(httpStatusCode) {
                        
                        DispatchQueue.main.async {
                            successHandler(data)
                        }
                        
                    } else {
                        
                        DispatchQueue.main.async {
                            errorHandler(HMDARestApiError.unacceptableStatusCode(httpStatusCode))
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        task.resume()
    }
    
    public func dataRequest(_ completionHandler: @escaping APICompletionHandler, _ errorHandler: @escaping APIErrorHandler, _ dataHandler: @escaping APIDataHandler) throws {
        
        guard session != nil else {
            throw HMDARestApiError.sessionNotSet
        }
        
        guard urlRequest != nil else {
            throw HMDARestApiError.requestNotSet
        }
        
        self.completionHandler = completionHandler
        self.errorHandler = errorHandler
        self.dataHandler = dataHandler
        self.uploadHandler = nil
        
        let task = session!.dataTask(with: urlRequest!)
        task.resume()
    }
    
    
    public func uploadRequest(_ uploadData: Data, _ completionHandler: @escaping APICompletionHandler, _ errorHandler: @escaping APIErrorHandler, _ uploadHandler: @escaping APIUploadHandler) throws {
        
        guard session != nil else {
            throw HMDARestApiError.sessionNotSet
        }
        
        guard urlRequest != nil else {
            throw HMDARestApiError.requestNotSet
        }
        
        self.completionHandler = completionHandler
        self.errorHandler = errorHandler
        self.dataHandler = nil
        self.uploadHandler = uploadHandler
        
        let task = session!.uploadTask(with: urlRequest!, from: uploadData)
        task.resume()
    }
    
    
    public func uploadRequest(_ uploadDataFile: URL, _ completionHandler: @escaping APICompletionHandler, _ errorHandler: @escaping APIErrorHandler, _ uploadHandler: @escaping APIUploadHandler) throws {
        
        guard session != nil else {
            throw HMDARestApiError.sessionNotSet
        }
        
        guard urlRequest != nil else {
            throw HMDARestApiError.requestNotSet
        }
        
        self.completionHandler = completionHandler
        self.errorHandler = errorHandler
        self.dataHandler = nil
        self.uploadHandler = uploadHandler
        
        let task = session!.uploadTask(with: urlRequest!, fromFile: uploadDataFile)
        task.resume()
    }
    
    public func jsonRequest(_ successHandler: @escaping APIJSONHandler, _ errorHandler: @escaping APIErrorHandler) throws {
        
        guard session != nil else {
            throw HMDARestApiError.sessionNotSet
        }
        
        guard urlRequest != nil else {
            throw HMDARestApiError.requestNotSet
        }
        
        let task = session!.dataTask(with: urlRequest!) { (data, response, error) in
            let httpStatusCode = ((response as? HTTPURLResponse)?.statusCode)!
            
            if error != nil {
                
                DispatchQueue.main.async {
                    errorHandler(HMDARestApiError.unknownError(error!))
                }
                
            } else {
                
                if self.validStatusCodeRange == nil {
                    
                    if let jsonObject = data?.jsonObject() {
                        
                        DispatchQueue.main.async {
                            successHandler(jsonObject)
                        }
                        
                    } else {
                        
                        DispatchQueue.main.async {
                            errorHandler(HMDARestApiError.invalidJSON)
                        }
                        
                    }
                    
                } else {
                    
                    if self.validStatusCodeRange!.contains(httpStatusCode) {
                        
                        if let jsonObject = data?.jsonObject() {
                            
                            DispatchQueue.main.async {
                                successHandler(jsonObject)
                            }
                            
                        } else {
                            
                            DispatchQueue.main.async {
                                errorHandler(HMDARestApiError.invalidJSON)
                            }
                            
                        }
                        
                    } else {
                        
                        DispatchQueue.main.async {
                            errorHandler(HMDARestApiError.unacceptableStatusCode(httpStatusCode))
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        task.resume()
    }
    
    
    // MARK: - Delegates
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if error == nil {
            
            if errorHandler != nil {
                DispatchQueue.main.async {
                    self.errorHandler!(error)
                }
            }
            
        } else {
            
            if completionHandler != nil {
                DispatchQueue.main.async {
                    self.completionHandler!()
                }
            }
            
        }
        
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        if dataHandler != nil {
            DispatchQueue.main.async {
                self.dataHandler!(data)
            }
        }
        
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        if uploadHandler != nil {
            self.uploadHandler!(bytesSent, totalBytesSent, totalBytesExpectedToSend)
        }
        
    }
    
}


public extension URLSession {
    
    class var ephemeral: URLSession {
        return URLSession(configuration: URLSessionConfiguration.ephemeral)
    }
    
}
