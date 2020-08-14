//
//  TransactionListPresenter.swift
//  PayDay
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation
import Features
import Entities

class TransactionListPresenter {
    
    // MARK: - Properties
    private weak var view: TransactionListView!
    private weak var router: TransactionListPresentation!
    
    private let accountListUseCase: AccountListUseCase = .init(quality: .userInitiated,
                                                               priority: .veryHigh)
    private let transactionListUseCase: TransactionListUseCase = .init(quality: .userInteractive,
                                                                       priority: .high)
    private let currentAccountListener: Listener<Account> = .init()
    private let transactionListListener: Listener<Transaction> = .init()
    
    private let userId: Int
    private var currentAccountId: Int!
    private var data: [Transaction] = []

    // MARK: - Init/Deinit methods
    init(with view: TransactionListView, router: TransactionListPresentation) {
        self.view = view
        self.router = router
        userId = UserSessionController.shared.userIdentifier
        
        fetchAccountList()
    }
    
    deinit {
        accountListUseCase.cancelAllOperations()
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
                                    "Current" )
        
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

        var collectionUpdates: [ContentUpdate] = []
        
        transactionListListener.prepare(predicate: predicate, sortDescriptors: [])
            .success { [weak self] change in
                guard let self = self else {
                    return
                }
                
                switch change.changeType {
                case .initial:
                    self.data = change.data
                    self.view.reload(alerts: change.data)
                case .willChange:
                    collectionUpdates = []
                case .update(_, let atIndexPath, let type, let newIndexPath):
                    let update: ContentUpdate = (type: type, atIndexPath: atIndexPath, newIndexPath: newIndexPath)
                    collectionUpdates.append(update)
                case .didChange:
                    self.data = change.data
                    self.view.update(alerts: change.data, with: collectionUpdates)
                }
        }
        .performOnCurrentThread()
    }
    
    private func retrieveTransactions() {
        if transactionListUseCase.isExecuting() {
            transactionListUseCase.cancelAllOperations()
        }
        
        transactionListUseCase
            .prepare(accountId: currentAccountId)
            .perform()
    }
}
