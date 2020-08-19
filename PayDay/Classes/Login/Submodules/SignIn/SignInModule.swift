//
//  SignInModule.swift
//  PayDay
//
//  Created by Sapa Denys on 06.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

final class SignInModule {
    
    // MARK: - Properties
    private let view: SignInViewController
    private let presenter: SignInPresenter
    
    // MARK: - Init / Deinit methods
    init() {
        view = UIStoryboard.init(name: "Login", bundle: .main)
            .instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        presenter = SignInPresenter(with: view)
        view.presenter = presenter
    }
    
    // MARK: - Public methods
    func viewController() -> UIViewController {
        return view
    }
}
