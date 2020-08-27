//
//  TransactionListModule.swift
//  PayDay
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

final class TransactionListModule {

    // MARK: - Properties
    private let view: TransactionListViewController
    private let presenter: TransactionListPresenter

    // MARK: - Init / Deinit methods
    init() {
        guard let view = UIStoryboard.init(name: "TransactionList", bundle: .main)
            .instantiateViewController(withIdentifier: "TransactionListViewController")
            as? TransactionListViewController else {
                fatalError("Can't find TransactionListViewController view controller in TransactionList storyboard")
        }

        self.view = view
        presenter = TransactionListPresenter(with: view, router: view)
        view.presenter = presenter
    }

    // MARK: - Public methods
    func viewController() -> UIViewController {
        return view
    }
}
