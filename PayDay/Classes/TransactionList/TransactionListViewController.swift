//
//  TransactionListViewController.swift
//  PayDay
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

protocol TransactionListView: AnyObject {
    func reload(alerts: [TransactionDisplayable])
    func update(alerts: [TransactionDisplayable], with updates: [ContentUpdate])
}

class TransactionListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    var presenter: TransactionListPresenter!
    
    private var data: [TransactionDisplayable] = []
}

// MARK: - TransactionListView
extension TransactionListViewController: TransactionListView {
    
    func reload(alerts: [TransactionDisplayable]) {
        data = alerts
        
        guard tableView != nil else {
            return
        }
        
        tableView.reloadData()
    }
    
    func update(alerts: [TransactionDisplayable], with updates: [ContentUpdate]) {
        data = alerts
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: TransactionTableViewCell.self)
        
        cell.configure(with: data[indexPath.row])
        
        return cell
    }
}
