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

extension LoginViewController: LoginPresentation {
    
    func openTransactions() {
        let window = UIApplication.shared.keyWindow
        let navigationController = UINavigationController(rootViewController: TransactionListModule().viewController())
        window?.replaceRootViewControllerWith(navigationController)
    }
}
