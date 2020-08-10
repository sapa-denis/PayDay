//
//  QueueConformable.swift
//  Core
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

public protocol QueueConformable: class {
    var queue: OperationQueue { get }
}
