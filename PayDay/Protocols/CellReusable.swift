//
//  CellReusable.swift
//  PayDay
//
//  Created by Sapa Denys on 14.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

protocol CellReusable: class {
    static var reuseIdentifier: String { get }
}

extension CellReusable {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
