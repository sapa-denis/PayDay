//
//  AbstractDecoderBuilder.swift
//  Features
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Core

class AbstractDecoderBuilder<DecodableEntity>: DecoderBuildable where DecodableEntity: Decodable {

    typealias Entity = DecodableEntity
    
    // MARK: - Public method
    func build(with decoder: JSONDecoder, path: String?) -> CoreOperation<Data, DecodableEntity> {
        preconditionFailure("You can not use object of type AbstractDecoderBuilder directly.")
    }
}
