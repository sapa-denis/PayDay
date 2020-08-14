//
//  FeatureError.swift
//  Features
//
//  Created by Sapa Denys on 13.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

enum FeatureError {
    case serialization(_ type: Serialization)
    case coreData(_ type: CoreData)
    case customMessage(_ message: String)
    case customError(_ error: Error)
}

// MARK: - Serialization errors
extension FeatureError {
    
    enum Serialization {
        case decodingIncompleteContent(_ key: Any)
    }
}

// MARK: - CoreData errors
extension FeatureError {
    
    enum CoreData {
        case missingEntity(_ type: Any.Type, _ key: Any)
    }
}

// MARK: - LocalizedError
extension FeatureError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .serialization(let type):
            return type.localizedDescription
        case .coreData(let type):
            return type.localizedDescription
        case .customMessage(let message):
            return "Serialization error: \(message)"
        case .customError(let error):
            return "Serialization error: \(error.localizedDescription)"
        }
    }
}

extension FeatureError.Serialization: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .decodingIncompleteContent(let key):
            return "Failed to find object by key: '\(key)'"
        }
    }
}

extension FeatureError.CoreData: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .missingEntity(let type, let key):
            return "\(type) entity must exist by key: '\(key)'"
        }
    }
}
