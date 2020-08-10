//
//  NetworkRequesterBuilder.swift
//  Features
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Networking

struct NetworkRequesterBuilder: NetworkRequesterBuildable {
    
    func build(request: RequestConvertible?) -> NetworkExecutable {
        NetworkOperation(in: .networking, session: .main, request: request)
    }
}
