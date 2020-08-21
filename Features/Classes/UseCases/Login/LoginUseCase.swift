//
//  LoginUseCase.swift
//  Features
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Core
import CoreData
import Networking
import Entities

public final class LoginUseCase: UseCase<Int> {

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
    public func prepare(email: String,
                        password: String) -> Self {
        let request = PayDayRequest.authenticate(email: email, password: password)
        let networkRequest = container.networkRequestBuilder.build(request: request)

        let jsonDecoder = JSONDecoder()
        let context = NSPersistentContainer.newBackgroundContext()
        jsonDecoder.userInfo[CodingUserInfoKey.context] = context

        let decodeOperation = container.responseDecodeBuilder.build(with: jsonDecoder)

        let save = container.responseAdapterBuilder.build(in: .additional) { input in
            if case .failure(let error) = Result(catching: { try context.saveIfNeeded() }) {
                return .failure(error)
            }

            return input.map {
                Int($0.identifier)
            }
        }

        prepareExecution(for: networkRequest
            .then(decodeOperation)
            .then(save))

        return self
    }
}

// MARK: - Container declaration
extension LoginUseCase {

    public struct DependencyContainer {
        static var base: DependencyContainer {
            return DependencyContainer(networkRequestBuilder: NetworkRequesterBuilder(),
                                       responseDecodeBuilder: ResponseDecodingBuilder(),
                                       responseAdapterBuilder: ResponseAdapterBuilder())
        }

        let networkRequestBuilder: NetworkRequesterBuildable
        let responseDecodeBuilder: AbstractDecoderBuilder<User>
        let responseAdapterBuilder: AbstractAdditionalOperationBuilder<User, Int>
    }

    final class ResponseDecodingBuilder: AbstractDecoderBuilder<User> {

        override func build(with decoder: JSONDecoder, path: String? = nil) -> DecodeOperation<User> {
            DecodeOperation(in: .additional, decoder: decoder, path: path)
        }
    }

    final class ResponseAdapterBuilder: AbstractAdditionalOperationBuilder<User, Int> {

        override func build(in queue: OperationQueue,
                            closure: @escaping OperationCompletion) -> CoreOperationClosure<User, Int> {
            CoreOperationClosure(in: queue, closure: closure)
        }
    }
}
