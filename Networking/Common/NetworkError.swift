//
//  NetworkError.swift
//  Network
//
//  Created by Sapa Denys on 05.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

public enum NetworkError: Error {
    case noInternetConnection
    case invalidResponse(error: Error?)
    case unacceptableStatusCode(code: Int)
}
