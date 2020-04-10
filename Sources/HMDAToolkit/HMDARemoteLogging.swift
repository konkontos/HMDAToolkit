//
//  HMDARemoteLogging.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 08/01/2019.
//  Copyright © 2019 Handmade Apps Ltd. All rights reserved.
//

import Foundation

public enum HMDAFluentDLogError: Error {
    case invalidJsonObject
    case invalidHost
    case serverError(Int?,String?)
}

public class HMDARemoteLogging {
    
    private class func fluentDLogTask(endpoint: URL, tag: String, username: String?, password: String?, json: JSONObject) throws -> (URLSession, URLRequest) {
        
        guard endpoint.host != nil else {
            throw HMDAFluentDLogError.invalidHost
        }
        
        guard let jsonBodyStr = json.jsonPlainStr() else {
            throw HMDAFluentDLogError.invalidJsonObject
        }
        
        let requestURL = endpoint.appendingPathComponent(tag)
        
        var request = URLRequest(url: requestURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        
        let bodyStr = "json=\(jsonBodyStr)"
        
        request.httpBody = bodyStr.data(using: .utf8)
        
        var authorizationStr: String?
        
        if username != nil, password != nil {
            authorizationStr = "\(username!):\(password!)"
            let authData = authorizationStr!.data(using: .utf8)!
            authorizationStr = authData.base64EncodedString()
        }
        
        let sessionConfig = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: sessionConfig)
        
        request.setValue("Basic \(authorizationStr!)", forHTTPHeaderField: "Authorization")
        
        return (session, request)
    }
        
    public class func fluentDLog(endpoint: URL, tag: String, username: String?, password: String?, json: JSONObject, completionHandler: @escaping APIErrorHandler) throws {
        
        
        do {
            let taskConfig = try HMDARemoteLogging.fluentDLogTask(endpoint: endpoint,
                                                              tag: tag,
                                                              username: username,
                                                              password: password,
                                                              json: json)
            let (session, request) = taskConfig
            
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                
                let httpResponse = response as? HTTPURLResponse
                
                if error != nil || httpResponse?.statusCode != 200 {
                    completionHandler(HMDAFluentDLogError.serverError(httpResponse?.statusCode, httpResponse.debugDescription))
                } else {
                    completionHandler(nil)
                }
                
            }
            
            dataTask.resume()
        } catch (let error) {
            throw error
        }
        
    }
    
    public class func fluentDLog(endpoint: URL, tag: String, username: String?, password: String?, json: JSONObject) throws {
        
        
        do {
            let taskConfig = try HMDARemoteLogging.fluentDLogTask(endpoint: endpoint,
                                                                  tag: tag,
                                                                  username: username,
                                                                  password: password,
                                                                  json: json)
            let (session, request) = taskConfig
            
            let dataTask = session.dataTask(with: request)
            
            dataTask.resume()
        } catch (let error) {
            throw error
        }
        
    }
    
}


