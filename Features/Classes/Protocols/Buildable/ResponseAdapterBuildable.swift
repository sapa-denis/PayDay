//
//  ResponseAdapterBuildable.swift
//  Features
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Core

protocol ResponseAdapterBuildable: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func build(in queue: OperationQueue,
               closure: @escaping (_: Result<Input, Error>) -> Result<Output, Error>)
        -> CoreOperation<Input, Output>
}
