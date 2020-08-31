//
//  TransactionListPresenter.swift
//  PayDay
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Features
import Entities

final class TransactionListPresenter {

    // MARK: - Properties
    private weak var view: TransactionListView!
    private var router: TransactionListPresentation

    private let accountListUseCase: AccountListUseCase
    private let transactionListUseCase: TransactionListUseCase
    private let currentAccountListener: Listener<Account>
    private let transactionListListener: Listener<Transaction>

    private let userId: Int
    private var currentAccountId: Int!
    private var collectionContent: CollectionChange<Transaction>?

    // MARK: - Init/Deinit methods
    init(with view: TransactionListView,
         router: TransactionListPresentation,
         accountListUseCase: AccountListUseCase = .init(quality: .userInitiated,
                                                                    priority: .veryHigh),
         transactionListUseCase: TransactionListUseCase = .init(quality: .userInteractive,
                                                                            priority: .high),
         currentAccountListener: Listener<Account> = .init(),
         transactionListListener: Listener<Transaction> = .init()) {
        self.view = view
        self.router = router
        userId = UserSessionController.shared.userIdentifier

        self.accountListUseCase = accountListUseCase
        self.transactionListUseCase = transactionListUseCase
        self.currentAccountListener = currentAccountListener
        self.transactionListListener = transactionListListener

        fetchAccountList()
    }

    deinit {
        accountListUseCase.cancelAllOperations()
        transactionListUseCase.cancelAllOperations()

        currentAccountListener.cancelAllOperations()
        transactionListListener.cancelAllOperations()
    }

    // MARK: - Public methods
    func retrieveTransactions() {
        if transactionListUseCase.isExecuting() {
            transactionListUseCase.cancelAllOperations()
        }

        transactionListUseCase
            .prepare(accountId: currentAccountId)
            .always { [weak self] in
                self?.view.retreivingTransactionsDidEnd()
            }
            .perform()
    }

    func onDashboardTouchAction() {
        router.openDashboard(for: currentAccountId)
    }
}

// MARK: - Data providing methods
extension TransactionListPresenter {

    func numberOfSections() -> Int {
        guard let collectionContent = collectionContent else {
            return 0
        }

        return collectionContent.sectionedData.count
    }

    func numberOfElementsIn(section: Int) -> Int {
        guard let collectionContent = collectionContent else {
            return 0
        }

        return collectionContent.sectionedData[section].numberOfObjects
    }

    func title(for section: Int) -> String? {
        guard let collectionContent = collectionContent else {
            return nil
        }

        return collectionContent.sectionedData[section].name
    }

    func object(in section: Int, at index: Int) -> TransactionDisplayable {
        guard let transaction = collectionContent?.sectionedData[section].objects?[index] as? Transaction else {
            fatalError("Can't find Transaction at [\(section): \(index)]")
        }

        return transaction
    }
}

// MARK: - Private methods
extension TransactionListPresenter {

    private func fetchAccountList() {
        listenCurrentAccount()
        retriveAccountList()
    }

    private func fetchTransactions() {
        guard currentAccountId != nil else {
            return
        }

        listenTransactions()
        retrieveTransactions()
    }

    private func listenCurrentAccount() {
        let predicate = NSPredicate(format: "%K = %d AND %K = %@",
                                    #keyPath(Account.customer.identifier), userId,
                                    #keyPath(Account.type),
                                    "Current")

        currentAccountListener.prepare(predicate: predicate, sortDescriptors: [])
            .success { [weak self] change in
                guard let self = self,
                    let account = change.data.first else {
                        return
                }

                self.currentAccountId = Int(account.identifier)
                self.fetchTransactions()
            }
            .performOnCurrentThread()
    }

    private func retriveAccountList() {
        if accountListUseCase.isExecuting() {
            accountListUseCase.cancelAllOperations()
        }

        accountListUseCase
            .prepare(userId: userId)
            .perform()
    }

    private func listenTransactions() {
        let predicate = NSPredicate(format: "%K = %d",
                                    #keyPath(Transaction.account.identifier), currentAccountId)

        let sortDescriptor = NSSortDescriptor(key: #keyPath(Transaction.date), ascending: false)
        var collectionUpdates: [ContentUpdate] = []

        transactionListListener.prepare(predicate: predicate,
                                        sortDescriptors: [sortDescriptor],
                                        sectionNameKeyPath: "dateWithFormat")
            .success { [weak self] change in
                guard let self = self else {
                    return
                }

                switch change.changeType {
                case .initial:
                    self.collectionContent = change
                    self.view.reload()
                case .willChange:
                    collectionUpdates = []
                case .update(_, let atIndexPath, let type, let newIndexPath):
                    let update: ContentUpdate = (type: type, atIndexPath: atIndexPath, newIndexPath: newIndexPath)
                    collectionUpdates.append(update)
                case .didChange:
                    self.collectionContent = change
                    self.view.update(with: collectionUpdates)
                }
        }
        .performOnCurrentThread()
    }
}
