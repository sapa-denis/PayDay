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

    // MARK: - Init/Deinit methods
    init(with view: LoginView) {
        self.view = view
    }
}
