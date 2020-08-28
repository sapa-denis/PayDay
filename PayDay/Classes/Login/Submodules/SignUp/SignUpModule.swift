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
    init(with delegate: SignUpViewActionsDelegate?) {
        guard let view = UIStoryboard.init(name: "Login", bundle: .main)
            .instantiateViewController(withIdentifier: "SignUpViewController")
            as? SignUpViewController else {
                fatalError("Can't find SignUpViewController view controller in Login storyboard")
        }

        self.view = view
        presenter = SignUpPresenter(with: view)
        view.presenter = presenter
        view.delegate = delegate
    }

    // MARK: - Public methods
    func viewController() -> UIViewController {
        return view
    }
}
