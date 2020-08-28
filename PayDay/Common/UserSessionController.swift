//
//  UserSessionController.swift
//  PayDay
//
//  Created by Sapa Denys on 11.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Entities

final class UserSessionController {

    // MARK: - Static properties
    static let shared: UserSessionController = {
        UserSessionController()
    }()

    // MARK: - Properties
    var user: User?

    var authorizationStatus: AuthorizationStatus {
        didSet {
            switch authorizationStatus {
            case .notAuthorized:
                userListener.cancelAllOperations()
                userDefaults.removeUserId()
            case .authorized(let userId):
                userDefaults.userId = userId
                listenUser()
            }
        }
    }
    var userIdentifier: Int {
        switch authorizationStatus {
        case .authorized(let userId):
            return userId
        case .notAuthorized:
            fatalError("Set `authorizationStatus` as \(String(describing: AuthorizationStatus.authorized)) before")
        }
    }

    private let userDefaults: UserDefaultsAccessor
    private let userListener: Listener<User> = .init()

    // MARK: - Init / Deinit methods
    init(userDefaults: UserDefaultsAccessor = UserDefaultsAccessor.shared) {
        self.userDefaults = userDefaults

        let userId = self.userDefaults.userId
        if userId > 0 {
            authorizationStatus = .authorized(userId: userId)
            listenUser()
        } else {
            authorizationStatus = .notAuthorized
        }
    }

    deinit {
        userListener.cancelAllOperations()
    }
}

// MARK: - Private methods
extension UserSessionController {

    private func listenUser() {
        let predicate = NSPredicate(format: "%K = %d", #keyPath(User.identifier), userIdentifier)
        let sortDescriptors: [NSSortDescriptor] = []

        userListener
            .prepare(predicate: predicate,
                     sortDescriptors: sortDescriptors)
            .success { [weak self] change in
                guard let self = self else {
                    return
                }

                switch change.changeType {
                case .initial, .didChange:
                    guard let user = change.data.first else {
                        return
                    }

                    self.user = user
                default:
                    break
                }
            }
            .performOnCurrentThread()
    }
}

// MARK: - External declaration
extension UserSessionController {

    enum AuthorizationStatus {
        case notAuthorized
        case authorized(userId: Int)
    }
}
