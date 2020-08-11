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
    
    // MARK: - Outlets
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    // MARK: - Properties
    var presenter: LoginPresenter!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

// MARK: - Actions
extension LoginViewController {
    
    @IBAction private func onLoginButtonTouchUp(_ sender: UIButton) {
        presenter
            .loginAction(email: "Nadiah.Spoel@example.com",
                         password: "springs")
    }
}

// MARK: - LoginView
extension LoginViewController: LoginView {}
