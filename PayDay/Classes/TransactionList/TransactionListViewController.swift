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
    func retreivingTransactionsDidEnd()
}

class TransactionListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var presenter: TransactionListPresenter!

    private var isRefreshing: Bool = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        title = "Transactions"

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshControl

        setupView()
    }
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

    func retreivingTransactionsDidEnd() {
        isRefreshing = false
        tableView?.refreshControl?.endRefreshing()
    }
}

// MARK: - Actions
extension TransactionListViewController {

    @objc private func onDashboardButtonTouchUp() {
        presenter.onDashboardTouchAction()
    }

    @objc private func refreshContent(_ refreshControl: UIRefreshControl) {
        guard !isRefreshing else {
            tableView?.refreshControl?.endRefreshing()
            return
        }

        isRefreshing = true
        presenter.retrieveTransactions()
    }
}

extension TransactionListViewController {

    private func setupView() {
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.tintColor = UIColor(named: "placeholder")
            let dashboardItem = UIBarButtonItem(image: UIImage(named: "dashboard"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(onDashboardButtonTouchUp))
            navigationItem.setRightBarButton(dashboardItem, animated: false)
        }
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
