//
//  TransactionListRouter.swift
//  PayDay
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

protocol TransactionListPresentation: AnyObject {
    func openDashboard(for accountId: Int)
}

final class TransactionListRouter: TransactionListPresentation {

    // MARK: - Properties
    private weak var viewController: UIViewController!

    // MARK: - Init / Deinit methods
    init(with viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - TransactionListPresentation
    func openDashboard(for accountId: Int) {
        viewController
            .navigationController?
            .pushViewController(DashboardModule(accountId: accountId).viewController(),
                                animated: true)
    }
}
