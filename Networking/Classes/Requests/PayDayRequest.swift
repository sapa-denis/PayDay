//
//  PayDayRequest.swift
//  Networking
//
//  Created by Sapa Denys on 06.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

public enum PayDayRequest: RequestConvertible {
    
    case registrate(info: CustomerInfo)
    case authenticate(email: String, password: String)
    case accounts(userId: Int)
    case transactions(accountId: Int)
    
    public func uri() -> String {
        switch self {
        case .registrate:
            return .customersEndpoint
        case .authenticate:
            return .authenticateEndpoint
        case .accounts:
            return .accountsEndpoint
        case .transactions:
            return .transactionsEndpoint
        }
    }
    
    public func httpMethod() -> HTTPMethod {
        switch self {
        case .authenticate,
             .registrate:
            return .post
        case .accounts,
             .transactions:
            return .get
        }
    }
    
    public func query() -> [URLQueryItem]? {
        switch self {
        case .accounts(let userId):
            return [URLQueryItem(name: .customerId, value: "\(userId)")]
        case .transactions(let accountId):
            return [URLQueryItem(name: .accountId, value: "\(accountId)")]
        case .authenticate,
             .registrate:
            return nil
        }
    }
    
    public func encode(with encoder: JSONEncoder) throws -> Data? {
        switch self {
        case .registrate(let info):
            return try encoder.encode(info)
        case .authenticate(let email, let password):
            return try encodeAuthenticationParams(with: encoder,
                                                  email: email,
                                                  password: password)
        case .accounts,
             .transactions:
            return nil
        }
    }
}

extension PayDayRequest {
    
    private func encodeAuthenticationParams(with encoder: JSONEncoder,
                                            email: String,
                                            password: String) throws -> Data? {
        try encoder.encode(AuthenticationBody(email: email,
                                              password: password))
    }
}

// MARK: - External declaration
extension PayDayRequest {
    
    private struct AuthenticationBody: Encodable {
        
        let email: String
        let password: String
    }
    
    public struct CustomerInfo: Encodable {
        
        let firstName: String
        let lastName: String
        let gender: String
        let email: String
        let password: String
        let dateOfBirth: String
        let phone: String
        
        public init(firstName: String,
                    lastName: String,
                    gender: String,
                    email: String,
                    password: String,
                    dateOfBirth: String,
                    phone: String) {
            self.firstName = firstName
            self.lastName = lastName
            self.gender = gender
            self.email = email
            self.password = password
            self.dateOfBirth = dateOfBirth
            self.phone = phone
        }
     
        enum CodingKeys: String, CodingKey {
            case firstName = "First Name"
            case lastName = "Last Name"
            case email
            case phone
            case password
            case gender
            case dateOfBirth = "dob"
        }
        
    }
}

// MARK: - Endpoints
private extension String {
    static let authenticateEndpoint = "/authenticate"
    static let customersEndpoint = "/customers"
    static let transactionsEndpoint = "/transactions"
    static let accountsEndpoint = "/accounts"
}

// MARK: - Query keys
private extension String {
    static let accountId = "account_id"
    static let customerId = "customer_id"
}
