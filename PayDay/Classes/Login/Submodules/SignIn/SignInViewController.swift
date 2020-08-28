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
    @IBOutlet private weak var scrollView: UIScrollView!

    // MARK: - Properties
    var presenter: SignInPresenter!
    weak var delegate: SignInViewActionsDelegate?

    private var keyboardHandler: KeyboardHandler?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        keyboardHandler = KeyboardHandler(scrollView: scrollView, offset: 36)
        scrollView.addKeyboardDismissTapGesture()

        setupView()
    }
}

// MARK: - Actions
extension SignInViewController {

    @IBAction private func onLoginButtonTouchUp(_ sender: UIButton) {
        loginAction()
    }

    @IBAction private func onSwitchToRegistrationButtonTouchUp(_ sender: UIButton) {
        guard let delegate = delegate else {
            return
        }

        delegate.onSwitchToRegistrationAction()
    }
}

// MARK: - SignInView
extension SignInViewController: SignInView {

    func onSuccessfulRegistration() {
        guard let delegate = delegate else {
            return
        }

        delegate.onSuccessLogin()
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

    private func loginAction() {
        guard validateFields(),
            let email = emailTextField.text,
            let password = passwordTextField.text else {
                return
        }

        presenter
            .loginAction(email: email,
                         password: password)
    }
}

// MARK: - UITextFieldDelegate
extension SignInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            loginAction()
        default:
            break
        }

        return true
    }
}
