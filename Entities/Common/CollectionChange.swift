//
//  CollectionChange.swift
//  Entities
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import CoreData

public typealias FetchedResultsChangeType = NSFetchedResultsChangeType

public final class CollectionChange<Entity: NSManagedObject> {
    
    // MARK: - Properties
    public var changeType: ResultsChangeType
    public var data: [Entity] {
        return resultsController.fetchedObjects ?? []
    }
    
    public var sectionedData: [NSFetchedResultsSectionInfo] {
        resultsController.sections ?? []
    }
    
    private var resultsController: NSFetchedResultsController<Entity>
    
    // MARK: - Init / Deinit methods
    init(resultsController: NSFetchedResultsController<Entity>,
         type: ResultsChangeType = .initial) {
        
        self.resultsController = resultsController
        changeType = type
    }
}

extension CollectionChange {
    
    public enum ResultsChangeType {
        case initial
        case willChange
        case update(object: Entity, atIndexPath: IndexPath?, type: FetchedResultsChangeType, newIndexPath: IndexPath?)
        case didChange
    }
}

