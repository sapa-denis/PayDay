//
//  NetworkRequesterBuildable.swift
//  Features
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Networking

protocol NetworkRequesterBuildable {
    func build(request: RequestConvertible?) -> NetworkExecutable
}
