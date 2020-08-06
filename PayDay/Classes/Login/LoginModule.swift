//
//  LoginModule.swift
//  PayDay
//
//  Created by Sapa Denys on 06.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

final class LoginModule {
    
    // MARK: - Properties
    private let view: LoginViewController
    private let presenter: LoginPresenter
    
    // MARK: - Init / Deinit methods
    init() {
        view = UIStoryboard.init(name: "Login", bundle: .main)
            .instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        presenter = LoginPresenter(with: view)
        view.presenter = presenter
    }
    
    // MARK: - Public methods
    func viewController() -> UIViewController {
        return view
    }
}
