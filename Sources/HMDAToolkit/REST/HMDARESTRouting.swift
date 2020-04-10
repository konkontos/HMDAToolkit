//
//  HMDARESTRouting.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 05/10/2018.
//  Copyright © 2018 Handmade Apps Ltd. All rights reserved.
//

import Foundation

public protocol ApiRouter {
    var baseURL: URL {get}
}

public protocol URLConvertible {
    func asURL() throws -> URL
}

public protocol URLRequestConvertible {
    var urlRequest: URLRequest? { get }
}
