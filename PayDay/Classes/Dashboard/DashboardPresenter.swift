//
//  DashboardPresenter.swift
//  PayDay
//
//  Created by Sapa Denys on 16.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Entities
import Features

final class DashboardPresenter: NSObject {

    // MARK: - Properties
    private weak var view: DashboardView!
    private let repository: DashboardRepository

    private let accountId: Int

    private let transactionListUseCase: TransactionListUseCase
    private var collectionUpdates: [ContentUpdate] = []

    // MARK: - Init / Deinit methods
    init(with view: DashboardView,
         accountId: Int,
         repository: DashboardRepository = .init(),
         transactionListUseCase: TransactionListUseCase = .init(quality: .userInteractive,
                                                                priority: .high)) {
        self.view = view
        self.repository = repository
        self.accountId = accountId
        self.transactionListUseCase = transactionListUseCase

        super.init()

        fetchMonthlyReport()
        retrieveMonthlyReport()
    }

    deinit {
        transactionListUseCase.cancelAllOperations()
    }

    // MARK: - Public Methods
    func retrieveMonthlyReport() {
        if transactionListUseCase.isExecuting() {
            transactionListUseCase.cancelAllOperations()
        }

        transactionListUseCase
            .prepare(accountId: accountId)
            .always { [weak self] in
                self?.fetchMonthlyReport()
        }
        .perform()
    }
}

// MARK: - Data providing methods
extension DashboardPresenter {

    func numberOfSections() -> Int {
        return repository.numberOfSections()
    }

    func numberOfElementsIn(section: Int) -> Int {
        return repository.numberOfElementsIn(section: section)
    }

    func title(for section: Int) -> (String?, String?) {
        let sectionTitle = repository.title(forSection: section)

        let monthlyAmount = repository
            .objects(inSection: section)
            .reduce(0) { (result, data) -> Decimal in
                return result + data.amount
        }

        return (sectionTitle, monthlyAmount.usStringMoney)
    }

    func object(in section: Int, at index: Int) -> CategoryDisplayable {
        return repository.objects(inSection: section)[index]
    }
}

extension DashboardPresenter {

    private func fetchMonthlyReport() {
        try? repository.executeRequest()

        view.retreivingContentDidEnd()
        view.reload()
    }
}
