//
//  SignUpPresenter.swift
//  PayDay
//
//  Created by Sapa Denys on 18.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Features
import Entities

typealias Gender = User.Gender
typealias CustomerInfo = Features.CustomerInfo

final class SignUpPresenter {

    // MARK: - Properties
    private weak var view: SignUpView!

    private let registrationUseCase: RegistrationUseCase = RegistrationUseCase(quality: .userInitiated,
                                                                               priority: .veryHigh)

    // MARK: - Init/Deinit methods
    init(with view: SignUpView) {
        self.view = view
    }

    deinit {
        registrationUseCase.cancelAllOperations()
    }

    // MARK: - Public methods
    func loginAction(with customerInfo: CustomerInfo) {
        if registrationUseCase.isExecuting() {
            registrationUseCase.cancelAllOperations()
        }

        registrationUseCase
            .prepare(with: customerInfo)
            .success { [weak self] userId in
                UserSessionController.shared.authorizationStatus = .authorized(userId: userId)
                self?.view.onSuccessfulRegistration()
        }
        .perform()
    }
}
