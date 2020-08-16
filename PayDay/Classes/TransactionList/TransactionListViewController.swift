//
//  TransactionListViewController.swift
//  PayDay
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

protocol TransactionListView: AnyObject {
    func reload()
    func update(with updates: [ContentUpdate])
}

class TransactionListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    var presenter: TransactionListPresenter!
}

// MARK: - TransactionListView
extension TransactionListViewController: TransactionListView {
    
    func reload() {
        guard tableView != nil else {
            return
        }
        
        tableView.reloadData()
    }
    
    func update(with updates: [ContentUpdate]) {
        guard tableView != nil else {
            return
        }
        
        tableView.beginUpdates()
        tableView.perform(updates: updates)
        tableView.endUpdates()
    }
}

// MARK: - UITableViewDataSource
extension TransactionListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfElementsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.title(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: TransactionTableViewCell.self)
        
        let data = presenter.object(in: indexPath.section, at: indexPath.row)
        cell.configure(with: data)
        
        return cell
    }
}
