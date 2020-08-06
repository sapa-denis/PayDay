//
//  LoginViewController.swift
//  PayDay
//
//  Created by Sapa Denys on 06.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

protocol LoginView: AnyObject {
    
}

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: LoginPresenter!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

// MARK: - LoginView
extension LoginViewController: LoginView {}
