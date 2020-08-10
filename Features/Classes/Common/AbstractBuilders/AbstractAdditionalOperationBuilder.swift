//
//  AbstractAdditionalOperationBuilder.swift
//  Features
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Core

class AbstractAdditionalOperationBuilder<InputType, OutputType>: ResponseAdapterBuildable {
    typealias Input = InputType
    typealias Output = OutputType
    
    typealias OperationCompletion = (Result<InputType, Error>) -> Result<OutputType, Error>
    
    func build(in queue: OperationQueue, closure: @escaping OperationCompletion) -> CoreOperation<InputType, OutputType> {
        preconditionFailure("You can not use object of type AbstractResponseAdapterBuildable directly.")
    }
}
