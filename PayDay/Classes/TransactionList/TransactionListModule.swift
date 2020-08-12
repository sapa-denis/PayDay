//
//  TransactionListModule.swift
//  PayDay
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

class TransactionListModule {

    // MARK: - Properties
    private let view: TransactionListViewController
    private let presenter: TransactionListPresenter
    
    // MARK: - Init / Deinit methods
    init() {
        view = UIStoryboard.init(name: "TransactionList", bundle: .main)
            .instantiateViewController(withIdentifier: "TransactionListViewController") as! TransactionListViewController
        presenter = TransactionListPresenter(with: view, router: view)
        view.presenter = presenter
    }
    
    // MARK: - Public methods
    func viewController() -> UIViewController {
        return view
    }
}
