//
//  TransactionListRouter.swift
//  PayDay
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//



protocol TransactionListPresentation: AnyObject {
    func openDashboard()
}

extension TransactionListViewController: TransactionListPresentation {
    
    func openDashboard() {
        navigationController?.pushViewController(DashboardModule().viewController(),
                                                 animated: true)
    }
}
