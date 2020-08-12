//
//  AccountsUseCase.swift
//  Features
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import CoreData
import Core
import Entities
import Networking

final public class AccountsUseCase: UseCase<Void> {

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
        let request = PayDayRequest.accounts(userId: userId)
        let networkRequest = container.networkRequestBuilder.build(request: request)
        
        let jsonDecoder = JSONDecoder()
        let context = NSPersistentContainer.newBackgroundContext()
        jsonDecoder.userInfo[CodingUserInfoKey.context] = context
        
        let decodeOperation = container.responseDecodeBuilder.build(with: jsonDecoder)
        
        let save = container.responseAdapterBuilder.build(in: .additional) { input in
            return Result {
                try context.saveIfNeeded()
            }
        }
        
        prepareExecution(for: networkRequest
            .then(decodeOperation)
            .then(save))
        
        return self
    }
}

// MARK: - Container declaration
extension AccountsUseCase {
    
    public struct DependencyContainer {
        static var base: DependencyContainer {
            return DependencyContainer(networkRequestBuilder: NetworkRequesterBuilder(),
                                       responseDecodeBuilder: ResponseDecodingBuilder(),
                                       responseAdapterBuilder: ResponseAdapterBuilder())
        }
        
        let networkRequestBuilder: NetworkRequesterBuildable
        let responseDecodeBuilder: AbstractDecoderBuilder<[Account]>
        let responseAdapterBuilder: AbstractAdditionalOperationBuilder<[Account], Void>
    }
    
    final class ResponseDecodingBuilder: AbstractDecoderBuilder<[Account]> {

        override func build(with decoder: JSONDecoder, path: String? = nil) -> DecodeOperation<[Account]> {
            DecodeOperation(in: .additional, decoder: decoder, path: path)
        }
    }
    
    final class ResponseAdapterBuilder: AbstractAdditionalOperationBuilder<[Account], Void> {
        
        override func build(in queue: OperationQueue,
                            closure: @escaping OperationCompletion) -> CoreOperationClosure<[Account], Void> {
            CoreOperationClosure(in: queue, closure: closure)
        }
    }
}
