//
//  AppDelegate.swift
//  PayDay
//
//  Created by Sapa Denys on 05.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit
import CoreData
import Entities

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = NSPersistentContainer.container

        window = UIWindow(frame: UIScreen.main.bounds)

        let authorizationStatus = UserSessionController.shared.authorizationStatus
        switch authorizationStatus {
        case .authorized:
            let viewController = TransactionListModule().viewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            window?.rootViewController = navigationController
        case .notAuthorized:
            window?.rootViewController = LoginModule().viewController()

        }
        window?.makeKeyAndVisible()

        return true
    }
}
