//
//  TransactionListViewController.swift
//  PayDay
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

protocol TransactionListView: AnyObject {
    
}

class TransactionListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    var presenter: TransactionListPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension TransactionListViewController: TransactionListView {
    
}
