//
//  UserDefaultsAccessor.swift
//  PayDay
//
//  Created by Sapa Denys on 11.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

final class UserDefaultsAccessor {
    
    static let shared: UserDefaultsAccessor = {
        UserDefaultsAccessor()
    }()
    
    var userId: Int {
        get {
            UserDefaults.standard.integer(forKey: .userIdKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: .userIdKey)
        }
    }
    
    func removeUserId() {
        UserDefaults.standard.removeObject(forKey: .userIdKey)
    }
}

// MARK: - Keys
private extension String {
    static let userIdKey: String = "userIdKey"
}
