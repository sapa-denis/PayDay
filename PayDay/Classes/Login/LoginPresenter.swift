//
//  LoginPresenter.swift
//  PayDay
//
//  Created by Sapa Denys on 06.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation
import Features

final class LoginPresenter {

    // MARK: - Properties
    private weak var view: LoginView!
    private let loginUseCase: LoginUseCase = LoginUseCase(quality: .userInitiated,
                                                          priority: .veryHigh)
    
    // MARK: - Init / Deinit methods
    init(with view: LoginView) {
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
            .prepare(email: "Nadiah.Spoel@example.com", password: "springs")
            .perform()
    }
}
