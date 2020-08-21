//
//  DashboardModule.swift
//  PayDay
//
//  Created by Sapa Denys on 16.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

final class DashboardModule {
    // MARK: - Properties
    private let view: DashboardViewController
    private let presenter: DashboardPresenter

    // MARK: - Init / Deinit methods
    init(accountId: Int) {
        guard let view = UIStoryboard.init(name: "Dashboard", bundle: .main)
            .instantiateViewController(withIdentifier: "DashboardViewController")
            as? DashboardViewController else {
                fatalError("Can't find DashboardViewController view controller in Dashboard storyboard")
        }

        self.view = view
        presenter = DashboardPresenter(with: view, accountId: accountId)
        view.presenter = presenter
    }

    // MARK: - Public methods
    func viewController() -> UIViewController {
        return view
    }
}
