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
    private let currentAccountListener: Listener<Account> = .init()
    
    private let userId: Int
    private var currentAccountId: Int!

    // MARK: - Init/Deinit methods
    init(with view: TransactionListView, router: TransactionListPresentation) {
        self.view = view
        self.router = router
        userId = UserSessionController.shared.userIdentifier
        
        fetchAccountList()
        fetchTransactions()
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
}
