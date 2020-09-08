//
//  CoreOperationClosure.swift
//  Features
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Core

public final class CoreOperationClosure<InputType, OutputType>: CoreOperation<InputType, OutputType> {

    // MARK: - Properties
    private var execution: (_ input: Result<InputType, Error>) -> Result<OutputType, Error>

    // MARK: - Init / Deinit methods
    public required init(in queue: OperationQueue,
                         closure: @escaping (_: Result<InputType, Error>) -> Result<OutputType, Error>) {

        execution = closure
        super.init(in: queue)
    }

    deinit {
        print("Deinit CoreOperationClosure")
    }

    // MARK: - Life Cycle
    public override func main() {
        guard canProceed() else { return }

        output = execution(input)
        finished()
    }
}
