//
//  SignUpViewController.swift
//  PayDay
//
//  Created by Sapa Denys on 18.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

protocol SignUpView: AnyObject {
    func onSuccessfulRegistration()
}

final class SignUpViewController: UITableViewController {

    // MARK: - Outlest
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordConfirmationTextField: UITextField!

    @IBOutlet private weak var maleRadioButtonImageView: UIImageView!
    @IBOutlet private weak var femaleRadioButtonImageView: UIImageView!

    @IBOutlet private weak var dayTextField: UITextField!
    @IBOutlet private weak var monthTextField: UITextField!
    @IBOutlet private weak var yearTextField: UITextField!

    @IBOutlet private weak var signUpButton: UIButton!

    // MARK: - Properties
    var presenter: SignUpPresenter!

    private var gender: Gender?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.keyboardDismissMode = .onDrag
        tableView.addKeyboardDismissTapGesture()

        setupView()
    }
}

// MARK: - SignUpView
extension SignUpViewController: SignUpView {

    func onSuccessfulRegistration() {
        UIApplication.shared.sendAction(#selector(SuccessLoginChainActionHandler
            .onSuccessLogin),
                                        to: nil,
                                        from: self,
                                        for: nil)
    }
}

// MARK: - Actions
extension SignUpViewController {

    @IBAction private func onMaleRadioButtonTouchUp() {
        maleRadioButtonImageView.isHighlighted = true
        femaleRadioButtonImageView.isHighlighted = false
        gender = .male
    }

    @IBAction private func onFemaleRadioButtonTouchUp() {
        maleRadioButtonImageView.isHighlighted = false
        femaleRadioButtonImageView.isHighlighted = true
        gender = .female
    }

    @IBAction private func onRegisterButtonTouchUp(_ sender: UIButton) {
        registerAction()
    }

    @IBAction private func onSwitchToLoginButtonTouchUp(_ sender: UIButton) {
        UIApplication.shared.sendAction(#selector(SwitchToLoginChainActionsHandler.onSwitchToLoginAction),
                                        to: nil,
                                        from: self,
                                        for: nil)
    }
}

// MARK: - Private methods
extension SignUpViewController {

    private func setupView() {
        firstNameTextField.apply(style: .regular)
        lastNameTextField.apply(style: .regular)
        phoneNumberTextField.apply(style: .regular)
        emailTextField.apply(style: .regular)
        passwordTextField.apply(style: .regular)
        passwordConfirmationTextField.apply(style: .regular)
        dayTextField.apply(style: .regular)
        monthTextField.apply(style: .regular)
        yearTextField.apply(style: .regular)

        signUpButton.layer.cornerRadius = Constants.cornerRadius
    }

    private func registerAction() {
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let email = emailTextField.text,
            let phone = phoneNumberTextField.text,
            let password = passwordTextField.text,
            let gender = gender,
            let day = dayTextField.text,
            let month = monthTextField.text,
            let year = yearTextField.text else {
                return
        }

        let customerInfo = CustomerInfo(firstName: firstName,
                                        lastName: lastName,
                                        gender: gender.rawValue,
                                        email: email,
                                        password: password,
                                        dateOfBirth: "\(day)-\(month)-\(year)",
            phone: phone)

        presenter.loginAction(with: customerInfo)
    }
}

extension SignUpViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            phoneNumberTextField.becomeFirstResponder()
        case phoneNumberTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordConfirmationTextField.becomeFirstResponder()
        case passwordConfirmationTextField:
            break
        case dayTextField:
            monthTextField.becomeFirstResponder()
        case monthTextField:
            yearTextField.becomeFirstResponder()
        case yearTextField:
            registerAction()
        default:
            break
        }

        return true
    }
}
