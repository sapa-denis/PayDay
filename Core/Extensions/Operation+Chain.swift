//
//  Operation+Chain.swift
//  Core
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

extension CoreOperation {

    // MARK: - Public methods
    public func then<U>(_ operation: CoreOperation<OutputType, U>) -> CoreOperation<OutputType, U> {
        operation.addDependency(self)
        completed = { [unowned self] in
            operation.input = self.output
        }

        return operation
    }

    public func then<T, U>(_ operation: CoreOperation<T, U>) -> CoreOperation<T, U> {
        operation.addDependency(self)
        return operation
    }
}

extension Operation {

    func cancelWithAllDependencies() {
        dependencies.forEach { $0.cancelWithAllDependencies() }
        cancel()
    }

    func applyQualityOfServiceForAllDependencies(with quality: QualityOfService,
                                                 queuePriority priority: Operation.QueuePriority) {
        qualityOfService = quality
        queuePriority = priority
        dependencies.forEach { $0.applyQualityOfServiceForAllDependencies(with: quality,
                                                                          queuePriority: priority) }
    }
}
