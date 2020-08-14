//
//  CollectionContentUpdating.swift
//  PayDay
//
//  Created by Sapa Denys on 14.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation


typealias ContentUpdate = (type: ResultChanges, atIndexPath: IndexPath?, newIndexPath: IndexPath?)

protocol CollectionContentUpdating {
    func perform(updates: [ContentUpdate])
}
