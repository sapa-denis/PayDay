//
//  NSManagedObjectContext.swift
//  Entities
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import CoreData

public typealias FetchResultObject = NSFetchRequestResult & NSObject
private let semaphore = DispatchSemaphore(value: 0)

extension NSManagedObjectContext {

    // MARK: - Public methods
    public func saveIfNeeded() throws {
        guard hasChanges else {
            return
        }

        var savingError: Error?
        save { error in
            savingError = error
            semaphore.signal()
        }
        semaphore.wait()

        if let savingError = savingError {
            throw savingError
        }
    }

    public func first<ResultType: FetchResultObject>(where predicate: NSPredicate) throws -> ResultType? {
        let request: NSFetchRequest<ResultType> = createRequest(where: predicate)

        return try fetch(request).first
    }

    public func first<ResultType: FetchResultObject & Entity>(withPrimaryKey key: Int64) throws -> ResultType? {
        return try first(withPrimaryKey: NSNumber(value: key))
    }

    // MARK: - Internal methods
    func performAndWait<T>(_ block: () throws -> T) rethrows -> T {
        func rethrowHelper<T>(
            function: (() -> Void) -> Void,
            execute work: () throws -> T,
            rescue: ((Error) throws -> (T))
        ) rethrows -> T {
            var result: T?
            var thrownError: Error?
            withoutActuallyEscaping(work) { work in
                function {
                    do {
                        result = try work()
                    } catch {
                        thrownError = error
                    }
                }
            }
            if let error = thrownError {
                return try rescue(error)
            } else {
                return result!
            }
        }

        return try rethrowHelper(
            function: performAndWait, execute: block, rescue: { throw $0 }
        )
    }
}

// MARK: - Private methods
extension NSManagedObjectContext {

    private func createRequest<ResultType: FetchResultObject>(where predicate: NSPredicate?,
                                                              sortDescriptors: [NSSortDescriptor]? = nil) ->
                                                                NSFetchRequest<ResultType> {
        let request = NSFetchRequest<ResultType>(entityName: ResultType.className)
        request.returnsObjectsAsFaults = true
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors

        return request
    }

    private func first<ResultType: FetchResultObject & Entity>(withPrimaryKey key: NSObject) throws -> ResultType? {
        let predicate = NSPredicate(format: "\(ResultType.primaryKey) = %@", key)

        return try first(where: predicate)
    }

    private func save(with completionBlock: @escaping ((Error?) -> Void)) {
        let performBlock = {
            do {
                try self.save()
            } catch {
                completionBlock(error)
                return
            }

            if let parent = self.parent {
                parent.save(with: completionBlock)
            } else {
                completionBlock(nil)
            }
        }

        if case .mainQueueConcurrencyType = concurrencyType {
            performAndWait(performBlock)
        } else {
            perform(performBlock)
        }
    }
}
