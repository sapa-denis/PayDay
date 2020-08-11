//
//  Entity.swift
//  Entities
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

public protocol Entity: AnyObject {
    static var primaryKey: String { get }
}
