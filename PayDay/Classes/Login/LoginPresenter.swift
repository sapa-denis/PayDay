//
//  LoginPresenter.swift
//  PayDay
//
//  Created by Sapa Denys on 18.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

final class LoginPresenter {

    // MARK: - Properties
    private weak var view: LoginView!
    private var router: LoginRouter

    // MARK: - Init/Deinit methods
    init(with view: LoginView, router: LoginRouter) {
        self.view = view
        self.router = router
    }

    // MARK: - Public methods
    func onSuccessLoginAction() {
        router.openTransactions()
    }
}
