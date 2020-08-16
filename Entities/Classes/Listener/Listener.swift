//
//  Listener.swift
//  Entities
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import CoreData
import Core

public final class Listener<Entity: NSManagedObject>: UseCase<CollectionChange<Entity>> {
    
    // MARK: - Properties
    private var listen: ListenEntityOperation<Entity>?
    
    // MARK: - Public methods
    public func prepare(predicate: NSPredicate?,
                        sortDescriptors: [NSSortDescriptor],
                        fetchBatch: FetchSize? = nil,
                        sectionNameKeyPath: String? = nil) -> Self {
        cancelAllOperations()
        
        let listenEntityOperation = ListenEntityOperation<Entity>(
            in: OperationQueue.additional,
            context: NSPersistentContainer.container.viewContext,
            descriptors: sortDescriptors,
            predicate: predicate,
            fetchSize: fetchBatch,
            sectionNameKeyPath: sectionNameKeyPath
        )
        
        prepareExecution(for: listenEntityOperation)
        listen = listenEntityOperation
        
        return self
    }
    
    public override func cancelAllOperations() {
        super.cancelAllOperations()
        
        listen?.finished()
        listen?.outputUpdated = nil
    }
}
