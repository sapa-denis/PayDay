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
    public func then<U>(_ op: CoreOperation<OutputType, U>) -> CoreOperation<OutputType, U> {
        op.addDependency(self)
        completed = { [unowned self] in
            op.input = self.output
        }
    
        return op
    }
    
    public func then<T, U>(_ op: CoreOperation<T, U>) -> CoreOperation<T, U> {
        op.addDependency(self)
        return op
    }
}

extension Operation {
    
    func cancelWithAllDependencies() {
        dependencies.forEach { $0.cancelWithAllDependencies() }
        cancel()
    }
    
    func applyQualityOfServiceForAllDependencies(with quality: QualityOfService, queuePriority priority: Operation.QueuePriority) {
        qualityOfService = quality
        queuePriority = priority
        dependencies.forEach { $0.applyQualityOfServiceForAllDependencies(with: quality, queuePriority: priority) }
    }
}
