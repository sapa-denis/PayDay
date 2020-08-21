//
//  DecoderBuildable.swift
//  Features
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Core

protocol DecoderBuildable: AnyObject where Entity: Decodable {
    associatedtype Entity

    func build(with decoder: JSONDecoder, path: String?) -> CoreOperation<Data, Entity>
}
