//
//  LoginUseCase.swift
//  Features
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Core
import Networking

public final class LoginUseCase: UseCase<Void> {
    
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
        let request = AuthenticationRequest.authenticate(email: email, password: password)
        let networkRequest = container.networkRequestBuilder.build(request: request)
        
//        let jsonDecoder = JSONDecoder()
//        let context = NSPersistentContainer.newBackgroundContext()
//        jsonDecoder.userInfo[CodingUserInfoKey.context] = context
        
//        let decodeOperation = container.responseDecodeBuilder.build(with: jsonDecoder, path: "data")
        
        let save = container.responseAdapterBuilder.build(in: .additional) { input in
            
            switch input {
            case .success(let data):
                print("\(String(data: data, encoding: .utf8))")
            default:
                return .failure(NetworkError.unacceptableStatusCode(code: -100))
            }
            
            return input.map { (data) -> Void in
                return
            } //Result { try context.saveIfNeeded() }
        }
        
        prepareExecution(for: networkRequest
//            .then(decodeOperation)
            .then(save))
        
        return self
    }
}

// MARK: - Container declaration
extension LoginUseCase {
    
    public struct DependencyContainer {
        static var base: DependencyContainer {
            return DependencyContainer(networkRequestBuilder: NetworkRequesterBuilder(),
//                                       responseDecodeBuilder: ResponseDecodingBuilder(),
                                       responseAdapterBuilder: ResponseAdapterBuilder())
        }
        
        let networkRequestBuilder: NetworkRequesterBuildable
//        let responseDecodeBuilder: AbstractDecoderBuilder<Int>
        let responseAdapterBuilder: AbstractAdditionalOperationBuilder<Data, Void>
    }
    
//    final class ResponseDecodingBuilder: AbstractDecoderBuilder<Int> {
//
//        override func build(with decoder: JSONDecoder, path: String?) -> DecodeOperation<Int> {
//            DecodeOperation(in: .additional, decoder: decoder, path: path)
//        }
//    }
    
    final class ResponseAdapterBuilder: AbstractAdditionalOperationBuilder<Data, Void> {
        
        override func build(in queue: OperationQueue,
                            closure: @escaping OperationCompletion) -> CoreOperationClosure<Data, Void> {
            CoreOperationClosure(in: queue, closure: closure)
        }
    }
}
