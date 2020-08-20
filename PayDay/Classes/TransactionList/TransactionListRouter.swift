//
//  TransactionListRouter.swift
//  PayDay
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//



protocol TransactionListPresentation: AnyObject {
    func openDashboard(for accountId: Int)
}

extension TransactionListViewController: TransactionListPresentation {
    
    func openDashboard(for accountId: Int) {
        navigationController?.pushViewController(DashboardModule(accountId: accountId).viewController(),
                                                 animated: true)
    }
}
