//
//  SignInViewController.swift
//  PayDay
//
//  Created by Sapa Denys on 06.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

protocol SignInView: AnyObject {
    func onSuccessfulRegistration()
}

final class SignInViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    // MARK: - Properties
    var presenter: SignInPresenter!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}

// MARK: - Actions
extension SignInViewController {
    
    @IBAction private func onLoginButtonTouchUp(_ sender: UIButton) {
        guard validateFields(),
            let email = emailTextField.text,
            let password = passwordTextField.text else {
                return
        }
        
        presenter
            .loginAction(email: email,
                         password: password)
    }
    
    @IBAction private func onSwitchToRegistrationButtonTouchUp(_ sender: UIButton) {
        UIApplication.shared.sendAction(#selector(SwitchToRegistrationChainActionsHandler
                                                  .onSwitchToRegistrationAction),
                                        to: nil,
                                        from: self,
                                        for: nil)
    }
}

// MARK: - SignInView
extension SignInViewController: SignInView {
    
    func onSuccessfulRegistration() {
        UIApplication.shared.sendAction(#selector(SuccessLoginChainActionHandler
            .onSuccessLogin),
                                        to: nil,
                                        from: self,
                                        for: nil)
    }
}

// MARK: - Private methods
extension SignInViewController {
    
    private func setupView() {
        emailTextField.apply(style: .regular)
        passwordTextField.apply(style: .regular)
        
        loginButton.layer.cornerRadius = Constants.cornerRadius
    }
    
    private func validateFields() -> Bool {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                return false
        }
        
        return email.isEmail && password.count >= 6
    }
}
