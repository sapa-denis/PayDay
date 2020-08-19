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

class SignUpViewController: UITableViewController {
    
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

    // MARK: - Properties
    var presenter: SignUpPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    @IBAction private func onFemaleRadioButtonTouchUp() {
        maleRadioButtonImageView.isHighlighted = false
        femaleRadioButtonImageView.isHighlighted = true
    }
    
    @IBAction private func onRegisterButtonTouchUp(_ sender: UIButton) {
        registerAction()
    }
    
    @IBAction private func onSwitchToLoginButtonTouchUp(_ sender: UIButton) {
        UIApplication.shared.sendAction(#selector(SwitchToLoginChainActionsHandler
                                                  .onSwitchToLoginAction),
                                        to: nil,
                                        from: self,
                                        for: nil)
    }
}

// MARK: - Private methods
extension SignUpViewController {
    
    private func registerAction() {
//        presenter.loginAction(with: <#T##String#>,
//                              lastName: <#T##String#>,
//                              email: <#T##String#>,
//                              phone: <#T##String#>,
//                              password: <#T##String#>,
//                              gender: <#T##String#>,
//                              dateOfBirth: <#T##String#>)
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
