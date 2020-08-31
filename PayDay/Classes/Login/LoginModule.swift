//
//  LoginModule.swift
//  PayDay
//
//  Created by Sapa Denys on 18.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

final class LoginModule {

    // MARK: - Properties
    private let view: LoginViewController
    private let presenter: LoginPresenter

    // MARK: - Init / Deinit methods
    init() {
        guard let view = UIStoryboard.init(name: "Login", bundle: .main)
            .instantiateViewController(withIdentifier: "LoginViewController")
            as? LoginViewController else {
              fatalError("Can't find LoginViewController view controller in Login storyboard")
        }

        self.view = view
        let router = LoginRouter()
        presenter = LoginPresenter(with: view, router: router)
        view.presenter = presenter
    }

    // MARK: - Public methods
    func viewController() -> UIViewController {
        return view
    }
}
