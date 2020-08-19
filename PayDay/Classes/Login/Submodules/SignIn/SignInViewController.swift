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
        applyStyle(for: emailTextField)
        applyStyle(for: passwordTextField)
        
        loginButton.layer.cornerRadius = Constants.cornerRadius
    }
    
    private func validateFields() -> Bool {
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {
                return false
        }
        
        return email.isEmail && password.count >= 6
    }
    
    private func applyStyle(for textField: UITextField) {
        let placeholder: String = textField.placeholder ?? ""
        let attributes: [NSAttributedString.Key: Any] = [
                        .foregroundColor: UIColor.placeholder,
                        .font: UIFont.general
        ]
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                             attributes: attributes)
        textField.textColor = .black
        textField.font = .general
        textField.layer.borderColor = UIColor.border.cgColor
        textField.layer.borderWidth = Constants.borderWidth
        textField.layer.cornerRadius = Constants.cornerRadius
    }
}
