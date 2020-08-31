//
//  LoginRouter.swift
//  PayDay
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

protocol LoginPresentation: AnyObject {
    func openTransactions()
}

final class LoginRouter: LoginPresentation {

    // MARK: - Properties
    private weak var viewController: UIViewController!

    // MARK: - LoginPresentation
    func openTransactions() {
        let window = UIApplication.shared.keyWindow
        let navigationController = UINavigationController(rootViewController: TransactionListModule().viewController())
        window?.replaceRootViewControllerWith(navigationController)
    }
}
