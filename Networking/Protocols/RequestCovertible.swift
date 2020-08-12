//
//  RequestCovertible.swift
//  Networking
//
//  Created by Sapa Denys on 06.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public protocol RequestConvertible {
    func absoluteURL() throws -> URL
    func httpMethod() -> HTTPMethod
    func headers() -> HTTPHeaders?
    func encode(with encoder: JSONEncoder) throws -> Data?
    func domain() throws -> URL
    func uri() throws -> String
    func query() -> [URLQueryItem]?
}

extension RequestConvertible {
    
    public func absoluteURL() throws -> URL {
        guard let uriString = try? uri(),
            var uriComponents = URLComponents(string: uriString) else {
                throw RequestConvertibleError.invalidURI
        }

        uriComponents.queryItems = (uriComponents.queryItems ?? []) + (query() ?? [])
        
        let host = try domain()
        guard let url = uriComponents.url(relativeTo: host) else {
            throw RequestConvertibleError.invalidAbsoluteURL
        }
        
        return url
    }
    
    public func headers() -> HTTPHeaders? {
        return nil
    }
    
    public func domain() throws -> URL {
        guard let host = URL(string: "http://localhost:3000") else {
            fatalError("Can't get API Host during making RequestConvertible request")
        }
        
        return host
    }
    
    public func asURLRequest() throws -> URLRequest {
        return try encodedRequest()
    }
    
    // MARK: - Private methods
    private func json(_ encoder: JSONEncoder) throws -> Data? {
        guard let data = try encode(with: encoder) else { return nil }
        return data
    }
    
    private func encodedRequest(encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
        let request = URLRequest(url: try absoluteURL())
        
        var encodedRequest = try JSONEncoder().encode(request, with: try json(encoder))
        encodedRequest.httpMethod = httpMethod().rawValue

        headers()?.forEach { encodedRequest.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        return encodedRequest
    }
}

// MARK: - Errors
public enum RequestConvertibleError: Error {
    case invalidAbsoluteURL
    case invalidURI
}
