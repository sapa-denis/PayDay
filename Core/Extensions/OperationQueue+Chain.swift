//
//  OperationQueue+Chain.swift
//  Core
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

extension OperationQueue {
        
    // MARK: - Private methods
    private func add(dependencies: [Operation & QueueConformable]) {
        for dependency in dependencies {
            if !dependency.dependencies.isEmpty {
                let dependencies = dependency.dependencies.compactMap{ $0 as? Operation & QueueConformable }
                add(dependencies: dependencies)
            }
            dependency.queue.addOperation(dependency)
        }
    }
    
    func addOperationChain(_ operation: Operation & QueueConformable) {
        let dependencies = operation.dependencies.compactMap{ $0 as? Operation & QueueConformable }
        add(dependencies: dependencies)
        operation.queue.addOperation(operation)
    }
}
