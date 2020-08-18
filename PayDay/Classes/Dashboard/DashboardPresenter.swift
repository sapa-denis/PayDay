//
//  DashboardPresenter.swift
//  PayDay
//
//  Created by Sapa Denys on 16.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation
import CoreData
import Entities

final class DashboardPresenter: NSObject, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    private weak var view: DashboardView!
    
    private var resultController: NSFetchedResultsController<NSFetchRequestResult>!
    private var collectionUpdates: [ContentUpdate] = []
    
    init(with view: DashboardView) {
        self.view = view
        
        super.init()
        
        fetchMonthlyStatistic()
    }
    
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
        
        let monthlyAmount = sectionData.reduce(0) { (result, data) -> Double in
            guard let totalAmount = data["totalAmount"] as? Double else {
                return 0
            }
            
            return result + totalAmount
        }
        
        return (sectionInfo.name, String(describing: monthlyAmount))

    }
    
    func object(in section: Int, at index: Int) -> CategoryDisplayable {
        guard let categoryInfo = resultController?.sections?[section].objects?[index] as? [String: Any] else {
            fatalError("Can't find Transaction at [\(section): \(index)]")
        }
        
        guard let categoryName = categoryInfo["category"] as? String else {
            fatalError("")
        }
        
        guard let amount = categoryInfo["totalAmount"] as? Double  else {
            fatalError("")
        }
        
        return CategoryDisplayable(name: categoryName, amount: String(describing: amount))
    }
}

extension DashboardPresenter {
    
    private func fetchMonthlyStatistic() {
        let context = NSPersistentContainer.container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        request.resultType = .dictionaryResultType
        
        let totalAmountExpression = NSExpressionDescription()
        totalAmountExpression.expressionResultType = .doubleAttributeType
        totalAmountExpression.expression = NSExpression(forFunction: "sum:",
                                                        arguments: [NSExpression(forKeyPath: "amount")])
        totalAmountExpression.name = "totalAmount"
        
        let date = Date()
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .month, value: -3, to: date)
        let components = calendar.dateComponents([.year, .month], from: startDate!)
        let foo = calendar.date(from: components)
        
        let predicate = NSPredicate(format:"%K >= %lf", argumentArray: [#keyPath(Transaction.date),
                                                                        foo!])
        
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
        
        view.reload()
    }
}




