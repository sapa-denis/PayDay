//
//  AuthenticationRequest.swift
//  Networking
//
//  Created by Sapa Denys on 06.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

public enum AuthenticationRequest: RequestConvertible {
    
    case authenticate(email: String, password: String)
    
    public func uri() -> String {
        switch self {
        case .authenticate:
            return .authenticateEndpoint
        }
    }
    
    public func httpMethod() -> HTTPMethod {
        switch self {
        case .authenticate:
            return .post
        }
    }
    
    public func encode(with encoder: JSONEncoder) throws -> Data? {
        switch self {
        case .authenticate(let email, let password):
            return try encodeAuthenticationParams(with: encoder,
                                                  email: email,
                                                  password: password)
        }
    }
}

extension AuthenticationRequest {
    
    private func encodeAuthenticationParams(with encoder: JSONEncoder,
                                            email: String,
                                            password: String) throws -> Data? {
        try encoder.encode(AuthenticationBody(email: email,
                                              password: password))
    }
}

// MARK: - External declaration
extension AuthenticationRequest {
    
    private struct AuthenticationBody: Encodable {
        
        let email: String
        let password: String
    }
}

// MARK: - Constants
private extension String {
    static let authenticateEndpoint = "/authenticate"
}
