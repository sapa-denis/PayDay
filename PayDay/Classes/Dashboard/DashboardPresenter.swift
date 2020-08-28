//
//  DashboardPresenter.swift
//  PayDay
//
//  Created by Sapa Denys on 16.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import CoreData
import Entities
import Features

final class DashboardPresenter: NSObject, NSFetchedResultsControllerDelegate {

    // MARK: - Properties
    private weak var view: DashboardView!

    private let accountId: Int
    private var resultController: NSFetchedResultsController<NSFetchRequestResult>!
    private let transactionListUseCase: TransactionListUseCase
    private var collectionUpdates: [ContentUpdate] = []

    // MARK: - Init / Deinit methods
    init(with view: DashboardView,
         accountId: Int,
         transactionListUseCase: TransactionListUseCase = .init(quality: .userInteractive,
                                                                priority: .high)) {
        self.view = view
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
        guard let resultController = resultController else {
            return 0
        }

        return resultController.sections?.count ?? 0
    }

    func numberOfElementsIn(section: Int) -> Int {
        guard let resultController = resultController,
            let sectionInfo = resultController.sections?[section] else {
                return 0
        }

        return sectionInfo.numberOfObjects
    }

    func title(for section: Int) -> (String?, String?) {
        guard let resultController = resultController,
            let sectionInfo = resultController.sections?[section],
            let sectionData = sectionInfo.objects as? [[String: Any]]  else {
                return (nil, nil)
        }

        let monthlyAmount = sectionData.reduce(0) { (result, data) -> Decimal in
            guard let totalAmount = data["totalAmount"] as? Decimal else {
                return 0
            }

            return result + totalAmount
        }

        return (sectionInfo.name, monthlyAmount.usStringMoney)
    }

    func object(in section: Int, at index: Int) -> CategoryDisplayable {
        guard let categoryInfo = resultController?.sections?[section].objects?[index] as? [String: Any] else {
            fatalError("Can't find Transaction at [\(section): \(index)]")
        }

        guard let categoryName = categoryInfo["category"] as? String else {
            fatalError("")
        }

        guard let amount = categoryInfo["totalAmount"] as? Decimal  else {
            fatalError("")
        }

        return CategoryDisplayable(name: categoryName, amount: amount)
    }
}

extension DashboardPresenter {

    private func fetchMonthlyReport() {
        let context = NSPersistentContainer.container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        request.resultType = .dictionaryResultType

        let totalAmountExpression = NSExpressionDescription()
        totalAmountExpression.expressionResultType = .decimalAttributeType
        totalAmountExpression.expression = NSExpression(forFunction: "sum:",
                                                        arguments: [NSExpression(forKeyPath: "amount")])
        totalAmountExpression.name = "totalAmount"

        let date = Date()
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .month, value: -3, to: date)
        let components = calendar.dateComponents([.year, .month], from: startDate!)
        let startDateToFetch = calendar.date(from: components)

        let predicate = NSPredicate(format: "%K >= %lf", argumentArray: [#keyPath(Transaction.date),
                                                                        startDateToFetch!])

        request.predicate = predicate
        request.propertiesToGroupBy = ["category", "executionPeriod"]
        request.propertiesToFetch = ["category", "executionPeriod", totalAmountExpression]
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Transaction.date),
                                                    ascending: false)]

        resultController = NSFetchedResultsController(fetchRequest: request,
                                   managedObjectContext: context,
                                   sectionNameKeyPath: "executionPeriod",
                                   cacheName: nil)

        try? resultController.performFetch()

        view.retreivingContentDidEnd()
        view.reload()
    }
}
