//
//  UseCase.swift
//  Core
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

open class UseCase<OutputType> {

    // MARK: - Typealiases
    public typealias UseCaseCompletion = (OutputType) -> Void

    // MARK: - Properties
    private var operationCompletion: (() -> Void)!
    private var successCompletion: UseCaseCompletion?
    private var errorHandler: ((_ error: Error) -> Void)?
    private var alwaysCompletion: (() -> Void)?
    private var qualityOfService: QualityOfService
    private var notificationQueue: OperationQueue?
    private var queuePriority: Operation.QueuePriority
    private var operationChain: (Operation & QueueConformable)?

    // MARK: - Init / Deinit methods
    public init(quality: QualityOfService = .default, priority: Operation.QueuePriority = .normal) {
        qualityOfService = quality
        queuePriority = priority
    }

    // MARK: - Private methods
    private func configure<T>(chain: CoreOperation<T, OutputType>) {
        operationChain = chain
        operationCompletion = setupCompletion(for: chain)
        chain.completed = { [weak self] in
            guard let self = self else {
                return
            }

            self.operationCompletion()
        }

        chain.outputUpdated = { [weak self] data in
            guard let self = self else {
                return
            }

            _ = data.map(self.resolve)
        }
    }

    private func setupCompletion<T>(for operation: CoreOperation<T, OutputType>) -> (() -> Void) {
        return { [weak self] in
            let notifyInQueue = self?.notificationQueue ?? OperationQueue.main
            notifyInQueue.addOperation { [weak self] in
                guard let self = self else {
                    return
                }

                do {
                    let result = try operation.output.get()
                    self.successCompletion?(result)
                } catch {
                    self.errorHandler?(error)
                }
                self.alwaysCompletion?()
            }
        }
    }

    private func resolve(result: OutputType) {
        if let notifyInQueue = notificationQueue {
            notifyInQueue.addOperation { [weak self] in
                guard let self = self else {
                    return
                }

                self.successCompletion?(result)
            }
            return
        }
        successCompletion?(result)
    }

    // MARK: - Public methods
    public final func perform() {
        guard let chain = operationChain else {
            fatalError("Method 'prepareExecution(for:)' has not been called")
        }

        chain.queue.addOperationChain(chain)
    }

    public final func performOnCurrentThread() {
        guard let chain = operationChain else {
            fatalError("Method 'prepareExecution(for:)' has not been called")
        }

        notificationQueue = nil
        chain.start()
    }

    public final func prepareExecution<T>(for operation: CoreOperation<T, OutputType>,
                                          notify queue: OperationQueue = .main) {
        notificationQueue = queue
        configure(chain: operation)

        operation.applyQualityOfServiceForAllDependencies(with: qualityOfService, queuePriority: queuePriority)
    }

    @discardableResult
    public final func success(_ completion: @escaping UseCaseCompletion) -> Self {
        successCompletion = completion
        return self
    }

    @discardableResult
    public final func error(_ error: @escaping (_ error: Error) -> Void) -> Self {
        errorHandler = error
        return self
    }

    @discardableResult
    public final func always(_ completion: @escaping () -> Void) -> Self {
        alwaysCompletion = completion
        return self
    }

    open func cancelAllOperations() {
        alwaysCompletion?()
        operationChain?.cancelWithAllDependencies()
        operationCompletion = nil
    }

    public final func isExecuting() -> Bool {
        return !(operationChain?.isFinished ?? true)
    }

    public final func propagate(error: Error) {
        errorHandler?(error)
    }
}

// MARK: - Hashable
extension UseCase: Hashable {

    public func hash(into hasher: inout Hasher) {
        if let queue = operationChain?.queue {
            hasher.combine(queue)
        }
    }

    public static func == (lhs: UseCase<OutputType>, rhs: UseCase<OutputType>) -> Bool {
        guard let lhsChain = lhs.operationChain else {
            assertionFailure("Left hand side Operation Chain is released")
            return false
        }

        guard let rhsChain = rhs.operationChain else {
            assertionFailure("Right hand side Operation Chain is released")
            return false
        }

        return lhsChain == rhsChain
    }
}
