//
//  SignUpModule.swift
//  PayDay
//
//  Created by Sapa Denys on 18.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

final class SignUpModule {
    
    // MARK: - Properties
    private let view: SignUpViewController
    private let presenter: SignUpPresenter
    
    // MARK: - Init / Deinit methods
    init() {
        view = UIStoryboard.init(name: "Login", bundle: .main)
            .instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        presenter = SignUpPresenter(with: view)
        view.presenter = presenter
    }
    
    // MARK: - Public methods
    func viewController() -> UIViewController {
        return view
    }
}