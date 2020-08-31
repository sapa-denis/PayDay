//
//  DashboardRepository.swift
//  Features
//
//  Created by Sapa Denys on 29.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Entities
import CoreData

public final class DashboardRepository {

    // MARK: - Properties
    private var categoryInfosGruppedBySections: [Int: [CategoryInfo]] = [:]
    private lazy var resultController: NSFetchedResultsController<NSFetchRequestResult> = {
        NSFetchedResultsController(fetchRequest: fetchRequest(),
                                   managedObjectContext: NSPersistentContainer.container.viewContext,
                                   sectionNameKeyPath: #keyPath(Transaction.executionPeriod),
                                   cacheName: nil)
    }()

    // MARK: - Init / Deinit methods
    public init() {
    }

    // MARK: - Public methods
    public func executeRequest() throws {
        categoryInfosGruppedBySections = [:]
        try resultController.performFetch()
    }

    public func numberOfSections() -> Int {
        return resultController.sections?.count ?? 0
    }

    public func numberOfElementsIn(section: Int) -> Int {
        guard let sectionInfo = resultController.sections?[section] else {
            return 0
        }

        return sectionInfo.numberOfObjects
    }

    public func title(forSection section: Int) -> String? {
        guard let sectionInfo = resultController.sections?[section] else {
            return nil
        }

        return sectionInfo.name
    }

    public func objects(inSection section: Int) -> [CategoryInfo] {
        if let sectionInfo = categoryInfosGruppedBySections[section] {
            return sectionInfo
        } else {
            let newSectionInfo = resultController.sections?[section].objects?.compactMap { info -> CategoryInfo? in
                guard let categoryInfo = info as? [String: Any],
                    let categoryName = categoryInfo[#keyPath(Transaction.category)] as? String,
                    let amount = categoryInfo[String.totalAmount] as? Decimal else {
                        return nil
                }

                return CategoryInfo(name: categoryName, amount: amount)
            }

            guard let sectionInfo = newSectionInfo else {
                return []
            }

            categoryInfosGruppedBySections[section] = sectionInfo

            return sectionInfo
        }
    }
}

// MARK: - Private methods
extension DashboardRepository {

    private func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Transaction.entityName)
        request.resultType = .dictionaryResultType

        let totalAmountExpression = NSExpressionDescription()
        totalAmountExpression.expressionResultType = .decimalAttributeType
        totalAmountExpression.expression = NSExpression(forFunction: "sum:",
                                                        arguments: [NSExpression(forKeyPath: .amount)])
        totalAmountExpression.name = .totalAmount

        let date = Date()
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .month, value: -3, to: date)
        let components = calendar.dateComponents([.year, .month], from: startDate!)
        let startDateToFetch = calendar.date(from: components)

        let predicate = NSPredicate(format: "%K >= %lf", argumentArray: [#keyPath(Transaction.date),
                                                                        startDateToFetch!])

        request.predicate = predicate
        request.propertiesToGroupBy = [#keyPath(Transaction.category),
                                       #keyPath(Transaction.executionPeriod)]
        request.propertiesToFetch = [#keyPath(Transaction.category),
                                     #keyPath(Transaction.executionPeriod),
                                     totalAmountExpression]
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Transaction.date),
                                                    ascending: false)]

        return request
    }
}

// MARK: - External declaration
extension DashboardRepository {

    public struct CategoryInfo {

        // MARK: - Properties
        public let name: String
        public let amount: Decimal
    }
}

// MARK: - KeyPath
private extension String {

    static let amount: String = "amount"
    static let totalAmount: String = "totalAmount"
}
