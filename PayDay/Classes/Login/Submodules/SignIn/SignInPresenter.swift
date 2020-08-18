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
    private weak var router: SignInPresentation!
    private let loginUseCase: LoginUseCase = LoginUseCase(quality: .userInitiated,
                                                          priority: .veryHigh)
    
    // MARK: - Init / Deinit methods
    init(with view: SignInView, router: SignInPresentation) {
        self.view = view
        self.router = router
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
                self?.router.openTransactions()
            }
            .perform()
    }
}
