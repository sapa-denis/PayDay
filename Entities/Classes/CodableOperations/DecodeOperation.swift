//
//  DecodeOperation.swift
//  Entities
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Core

final public class DecodeOperation<Entity: Decodable>: CoreOperation<Data, Entity> {

    // MARK: - Properties
    private let jsonDecoder: JSONDecoder
    private let keyPath: String?

    // MARK: - Init / Deinit methods
    public init(in queue: OperationQueue,
                decoder: JSONDecoder = JSONDecoder(),
                path: String? = nil) {
        jsonDecoder = decoder
        keyPath = path
        super.init(in: queue)
    }

    deinit {
        print("Deinit DecodeOperation")
    }

    // MARK: - Life Cycle
    override public func main() {
        guard canProceed() else { return }

        output = input.flatMap(decode)
        finished()
    }

    // MARK: - Private methods
    private func decode(data: Data) -> Result<Entity, Error> {
        if let keyPath = keyPath {
            return Result { try jsonDecoder.decode(Entity.self, from: data, keyPath: keyPath) }
        } else {
            return Result { try jsonDecoder.decode(Entity.self, from: data) }
        }
    }
}

extension JSONDecoder {

    enum DecodeError: Error {
        case emptyData
    }

    public func decode<T: Decodable>(_ type: T.Type, from data: Data, keyPath: String) throws -> T {
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        if let nestedJson = (jsonObject as AnyObject).value(forKeyPath: keyPath) as? [Any] {
            let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedJson)
            return try decode(type, from: nestedJsonData)
        } else if let nestedJson = (jsonObject as AnyObject).value(forKeyPath: keyPath) as? [String: Any] {
            let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedJson)
            return try decode(type, from: nestedJsonData)
        } else {
            throw DecodeError.emptyData
        }
    }
}
