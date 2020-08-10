//
//  NetworkExecutable.swift
//  Features
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Core
import Networking

protocol NetworkExecutable: CoreOperation<RequestConvertible, Data> {
    init(in queue: OperationQueue, session: URLSession, request: RequestConvertible?)
}

extension NetworkOperation: NetworkExecutable {}
