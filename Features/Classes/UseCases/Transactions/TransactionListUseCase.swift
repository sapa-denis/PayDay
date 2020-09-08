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

public final class TransactionListUseCase: UseCase<Void> {

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

    deinit {
        print("Deinit TransactionListUseCase")
    }

    // MARK: - Public methods
    public func prepare(accountId: Int) -> Self {
        let request = PayDayRequest.transactions(accountId: accountId)
        let networkRequest = container.networkRequestBuilder.build(request: request)

        let jsonDecoder = JSONDecoder()
        let context = NSPersistentContainer.newBackgroundContext()
        jsonDecoder.userInfo[CodingUserInfoKey.context] = context

        let decodeOperation = container.responseDecodeBuilder.build(with: jsonDecoder)

        let bindTransactionsWithAccount = container.responseBindingOperation.build(in: .additional) { input in
            switch input {
            case .success(let transactions):
                let transactionsInContext = transactions.compactMap { transaction -> Transaction? in
                    guard transaction.managedObjectContext == context,
                        transaction.identifier != 0 else {
                            return nil
                    }

                    return transaction
                }

                guard transactionsInContext.count > 0 else {
                    return .success(())
                }

                let fetchRequest = NSFetchRequest<Account>(entityName: Account.className)
                fetchRequest.predicate = NSPredicate(format: "%K == %d",
                                                     #keyPath(Account.identifier),
                                                     accountId)

                guard let result = try? context.fetch(fetchRequest),
                    let account = result.first else {
                        return .failure(FeatureError.coreData(.missingEntity(Account.self, accountId)))
                }

                for transaction in transactionsInContext {
                    account.transactions?.insert(transaction)
                }

                return .success(())
            case .failure(let error):
                return .failure(error)
            }
        }

        let save = container.responseAdapterBuilder.build(in: .additional) { _ in
            return Result { try context.saveIfNeeded() }
        }

        prepareExecution(for: networkRequest
            .then(decodeOperation)
            .then(bindTransactionsWithAccount)
            .then(save))

        return self
    }
}

// MARK: - Container declaration
extension TransactionListUseCase {

    public struct DependencyContainer {
        static var base: DependencyContainer {
            return DependencyContainer(networkRequestBuilder: NetworkRequesterBuilder(),
                                       responseDecodeBuilder: ResponseDecodingBuilder(),
                                       responseBindingOperation: ResponseBindingOperationBuilder(),
                                       responseAdapterBuilder: ResponseAdapterBuilder())
        }

        let networkRequestBuilder: NetworkRequesterBuildable
        let responseDecodeBuilder: AbstractDecoderBuilder<[Transaction]>
        let responseBindingOperation: AbstractAdditionalOperationBuilder<[Transaction], Void>
        let responseAdapterBuilder: AbstractAdditionalOperationBuilder<Void, Void>
    }

    final class ResponseDecodingBuilder: AbstractDecoderBuilder<[Transaction]> {

        override func build(with decoder: JSONDecoder, path: String? = nil) -> DecodeOperation<[Transaction]> {
            DecodeOperation(in: .additional, decoder: decoder, path: path)
        }
    }

    final class ResponseBindingOperationBuilder: AbstractAdditionalOperationBuilder<[Transaction], Void> {

        override func build(in queue: OperationQueue,
                            closure: @escaping OperationCompletion) -> CoreOperationClosure<[Transaction], Void> {
            CoreOperationClosure(in: queue, closure: closure)
        }
    }

    final class ResponseAdapterBuilder: AbstractAdditionalOperationBuilder<Void, Void> {

        override func build(in queue: OperationQueue,
                            closure: @escaping OperationCompletion) -> CoreOperationClosure<Void, Void> {
            CoreOperationClosure(in: queue, closure: closure)
        }
    }
}
