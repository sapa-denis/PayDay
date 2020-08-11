//
//  NSPersistentContainer.swift
//  Entities
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import CoreData

extension NSPersistentContainer {
    
    // MARK: - Static properties
    private static let dataModelName = "PayDay"
    private static let payDayContainer = NSPersistentContainer(name: dataModelName)
    
    public static let container: NSPersistentContainer = {
        let semaphore = DispatchSemaphore(value: 0)
        payDayContainer.loadPersistentStores { _, store in
            if let existingStore = store {
                fatalError("Failed to load store: \(existingStore)")
            }
            semaphore.signal()
        }
        semaphore.wait()
        
        let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        print("SQLite file path: \(path)")
        
        return payDayContainer
    }()
    
    public static let backgroundContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = container.viewContext
        container.viewContext.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return context
    }()
    
    // MARK: - Public methods
    public static func newBackgroundContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = NSPersistentContainer.backgroundContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return context
    }
}
