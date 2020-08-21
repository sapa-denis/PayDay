//
//  JSONEncoder.swift
//  Networking
//
//  Created by Sapa Denys on 06.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

extension JSONEncoder {

    public enum HTTPHeaders: String {
        case contentType = "Content-Type"
        case accept = "Accept"
        case authorization = "Authorization"
        case acceptEncoding = "Accept-Encoding"

        func value() -> String {
            switch self {
            default: return "application/json"
            }
        }
    }

    public func encode(_ request: URLRequest, with data: Data? = nil) throws -> URLRequest {
        var urlRequest = request

        if urlRequest.value(forHTTPHeaderField: HTTPHeaders.contentType.rawValue) == nil {
            urlRequest.setValue(HTTPHeaders.contentType.value(), forHTTPHeaderField: HTTPHeaders.contentType.rawValue)
            urlRequest.setValue(HTTPHeaders.accept.value(), forHTTPHeaderField: HTTPHeaders.accept.rawValue)
        }

        guard let json = data else { return urlRequest }
        urlRequest.httpBody = json

        return urlRequest
    }
}
