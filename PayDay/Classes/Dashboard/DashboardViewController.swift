//
//  DashboardViewController.swift
//  PayDay
//
//  Created by Sapa Denys on 16.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

protocol DashboardView: AnyObject {
    func reload()
    func update(with updates: [ContentUpdate])
}

class DashboardViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    var presenter: DashboardPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Monthly Dashboard"
        
        self.tableView.register(DashboardSectionHeader.nib,
                                forHeaderFooterViewReuseIdentifier: DashboardSectionHeader.reuseIdentifier)
        reload()
    }
}
extension DashboardViewController: DashboardView {
    
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
extension DashboardViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfElementsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(at: indexPath, cellType: DashboardTableViewCell.self)
        
        let data = presenter.object(in: indexPath.section, at: indexPath.row)
        cell.configure(with: data)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DashboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView( withIdentifier: DashboardSectionHeader.reuseIdentifier) as? DashboardSectionHeader else {
                return nil
        }
        
        let headerInfo = presenter.title(for: section)
        
        view.configure(with: headerInfo.0, amount: headerInfo.1)
        
        return view
    }
}
