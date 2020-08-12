//
//  ListenEntityOperation.swift
//  Entities
//
//  Created by Sapa Denys on 11.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import CoreData
import Core

public typealias FetchSize = (limit: Int, offset: Int)

final public class ListenEntityOperation<Entity: NSManagedObject>: CoreOperation<Void, CollectionChange<Entity>>, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    private let listenerContext: NSManagedObjectContext
    private let contextualQueue: OperationQueue
    private let descriptors: [NSSortDescriptor]
    private let predicate: NSPredicate?
    private let fetchSize: FetchSize?
    private let asFaults: Bool
    private let cacheName: String?
    private var resultsController: NSFetchedResultsController<Entity>!
    private var collectionChange: CollectionChange<Entity>!
    
    // MARK: - Init / Deinit methods
    public init(in operationQueue: OperationQueue,
                context: NSManagedObjectContext,
                descriptors: [NSSortDescriptor],
                predicate: NSPredicate? = nil,
                fetchSize: FetchSize? = nil,
                asFaults: Bool = false,
                inMemoryOnly: Bool = true
        ) {
        
        contextualQueue = operationQueue
        listenerContext = context
        self.descriptors = descriptors
        self.predicate = predicate
        self.fetchSize = fetchSize
        self.asFaults = asFaults
        cacheName = inMemoryOnly ? nil : .cacheNameKey
        
        super.init(in: operationQueue)
    }
    
    // MARK: - Lifecycle
    override public func main() {
        guard canProceed() else { return }
        
        output = buildRequest()
            .flatMap(applyPredicate)
            .flatMap(applySort)
            .flatMap(applyLimitOffset)
            .flatMap(execute)
        
        guard case .failure = output else {
            outputUpdated?(output)
            cleanCache()
            return
        }
        
        finished()
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionChange.changeType = .willChange
        output = .success(collectionChange)
        outputUpdated?(output)
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                           didChange anObject: Any,
                           at indexPath: IndexPath?,
                           for type: NSFetchedResultsChangeType,
                           newIndexPath: IndexPath?) {
        
        guard let object = anObject as? Entity else { fatalError(.castingFatalMessage) }
        
        collectionChange.changeType = .update(object: object, atIndexPath: indexPath, type: type, newIndexPath: newIndexPath)
        output = .success(collectionChange)
        outputUpdated?(output)
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionChange.changeType = .didChange
        output = .success(collectionChange)
        outputUpdated?(output)
        
        cleanCache()
    }
}
    
    // MARK: - Private methods
extension ListenEntityOperation {
    
    private func buildRequest() -> Result<NSFetchRequest<Entity>, Error> {
        let request = NSFetchRequest<Entity>(entityName: Entity.entityName)
        request.returnsObjectsAsFaults = asFaults
        return .success(request)
    }
    
    private func applyPredicate(for request: NSFetchRequest<Entity>) -> Result<NSFetchRequest<Entity>, Error> {
        request.predicate = predicate
        return .success(request)
    }
    
    private func applySort(for request: NSFetchRequest<Entity>) -> Result<NSFetchRequest<Entity>, Error> {
        request.sortDescriptors = descriptors
        return .success(request)
    }
    
    private func applyLimitOffset(for request: NSFetchRequest<Entity>) -> Result<NSFetchRequest<Entity>, Error> {
        guard let batchSize = fetchSize  else {
            return .success(request)
        }
        
        request.fetchLimit = batchSize.limit
        request.fetchOffset = batchSize.offset
        return .success(request)
    }
    
    private func execute(request: NSFetchRequest<Entity>) -> Result<CollectionChange<Entity>, Error> {
        cleanCache()
        resultsController = NSFetchedResultsController(fetchRequest: request,
                                                       managedObjectContext: listenerContext,
                                                       sectionNameKeyPath: nil,
                                                       cacheName: cacheName)
        resultsController.delegate = self
        collectionChange = CollectionChange(resultsController: resultsController)
        
        let performedFetch = Result { try resultsController.performFetch() }
        if case .failure(let error) = performedFetch {
            return .failure(Errors.fetchRequestFailed(error: error))
        }
        
        return .success(collectionChange)
    }
    
    private func cleanCache() {
        NSFetchedResultsController<Entity>.deleteCache(withName: cacheName)
    }
}

// MARK: - Constants
private extension String {
    
    static let castingFatalMessage: String = "Can't cast ManagedObject to Entity"
    static let cacheNameKey: String = "CoreCache"
}

// MARK: - Errors
extension ListenEntityOperation {
    
    public enum Errors: Error {
        case fetchRequestFailed(error: Error?)
        case dataListeningFailed
    }
}

