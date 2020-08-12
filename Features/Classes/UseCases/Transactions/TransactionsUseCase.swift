//
//  TransactionsUseCase.swift
//  Features
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Core
import Entities
import CoreData
import Networking

class TransactionsUseCase: UseCase<Void> {

    // MARK: - Properties
    private let container: DependencyContainer
    
    // MARK: - Init / Deinit methods
    public init(dependency container: DependencyContainer) {
        self.container = container
    }
    
    public override init(quality: QualityOfService = .default,
                         priority: Operation.QueuePriority = .normal) {
        container = .base
        super.init(quality: quality, priority: priority)
    }
    
    // MARK: - Public methods
    public func prepare(userId: Int) -> Self {
        let request = PayDayRequest.transactions(userId: userId)
        let networkRequest = container.networkRequestBuilder.build(request: request)
        
        let jsonDecoder = JSONDecoder()
        let context = NSPersistentContainer.newBackgroundContext()
        jsonDecoder.userInfo[CodingUserInfoKey.context] = context
        
        let decodeOperation = container.responseDecodeBuilder.build(with: jsonDecoder)
        
        let save = container.responseAdapterBuilder.build(in: .additional) { input in
            return Result { try context.saveIfNeeded() }
        }
        
        prepareExecution(for: networkRequest
            .then(decodeOperation)
            .then(save))
        
        return self
    }
}

// MARK: - Container declaration
extension TransactionsUseCase {
    
    public struct DependencyContainer {
        static var base: DependencyContainer {
            return DependencyContainer(networkRequestBuilder: NetworkRequesterBuilder(),
                                       responseDecodeBuilder: ResponseDecodingBuilder(),
                                       responseAdapterBuilder: ResponseAdapterBuilder())
        }
        
        let networkRequestBuilder: NetworkRequesterBuildable
        let responseDecodeBuilder: AbstractDecoderBuilder<Transaction>
        let responseAdapterBuilder: AbstractAdditionalOperationBuilder<Transaction, Void>
    }
    
    final class ResponseDecodingBuilder: AbstractDecoderBuilder<Transaction> {

        override func build(with decoder: JSONDecoder, path: String? = nil) -> DecodeOperation<Transaction> {
            DecodeOperation(in: .additional, decoder: decoder, path: path)
        }
    }
    
    final class ResponseAdapterBuilder: AbstractAdditionalOperationBuilder<Transaction, Void> {
        
        override func build(in queue: OperationQueue,
                            closure: @escaping OperationCompletion) -> CoreOperationClosure<Transaction, Void> {
            CoreOperationClosure(in: queue, closure: closure)
        }
    }
}
