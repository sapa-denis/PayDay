//
//  TransactionListPresenter.swift
//  PayDay
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

class TransactionListPresenter {
    
    // MARK: - Properties
    private weak var view: TransactionListView!
    private weak var router: TransactionListPresentation!

    // MARK: - Init/Deinit methods
    init(with view: TransactionListView, router: TransactionListPresentation) {
        self.view = view
        self.router = router
    }
}
