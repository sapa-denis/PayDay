//
//  SignInPresenter.swift
//  PayDay
//
//  Created by Sapa Denys on 06.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation
import Features

final class SignInPresenter {

    // MARK: - Properties
    private weak var view: SignInView!
    private let loginUseCase: LoginUseCase = LoginUseCase(quality: .userInitiated,
                                                          priority: .veryHigh)
    
    // MARK: - Init / Deinit methods
    init(with view: SignInView) {
        self.view = view
    }
    
    deinit {
        loginUseCase.cancelAllOperations()
    }
    
    // MARK: - Public methods
    func loginAction(email: String, password: String) {
        if loginUseCase.isExecuting() {
            loginUseCase.cancelAllOperations()
        }
        
        loginUseCase
            .prepare(email: email, password: password)
            .success { [weak self] userId in
                UserSessionController.shared.authorizationStatus = .authorized(userId: userId)
                self?.view.onSuccessfulRegistration()
            }
            .perform()
    }
}
