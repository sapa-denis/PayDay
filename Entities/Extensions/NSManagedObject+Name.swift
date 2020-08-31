//
//  NSManagedObject+Name.swift
//  Entities
//
//  Created by Sapa Denys on 11.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import CoreData

public extension NSManagedObject {

    // MARK: - Static Properties
    static var entityName: String { return className  }
}

extension NSObject {

    public class var className: String {
        return String(describing: self)
    }
}
