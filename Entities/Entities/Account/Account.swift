//
//  Account.swift
//  Entities
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import CoreData
import Core

@objc(Account)
public final class Account: NSManagedObject, Decodable {

    // MARK: - Properties
    @NSManaged public private(set) var identifier: Int64
    @NSManaged public private(set) var iban: String
    @NSManaged public private(set) var type: String
    @NSManaged public private(set) var createdDate: String
    @NSManaged public private(set) var isActive: Bool
    @NSManaged public private(set) var customer: User?
    @NSManaged public var transactions: Set<Transaction>?

    // MARK: - Init / Deinit Methods
    required convenience public init(from decoder: Decoder) throws {
        guard let managedObjectContext = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: Account.entityName, in: managedObjectContext) else {
                fatalError("Failed to decode \(Account.self)")
        }

        self.init(entity: entity, insertInto: managedObjectContext)

        guard let container = try? decoder.container(keyedBy: CodingKeys.self),
            let identifier = try? container.decode(Int64.self, forKey: .identifier) else {
                managedObjectContext.delete(self)
                return
        }

        let object: Account = (try? managedObjectContext.first(withPrimaryKey: identifier)) ?? self

        do {
            try object.decode(container: container, in: managedObjectContext)
        } catch {
            managedObjectContext.delete(object)
        }

        if object != self {
            managedObjectContext.delete(self)
        }
    }

    // MARK: - Private Methods
    private func decode(container: KeyedDecodingContainer<CodingKeys>, in context: NSManagedObjectContext) throws {
        try context.performAndWait {
            identifier <>= try container.decode(Int64.self, forKey: .identifier)
            iban <>= try container.decode(String.self, forKey: .iban)
            type <>= try container.decode(String.self, forKey: .type)
            createdDate <>= try container.decode(String.self, forKey: .createdDate)
            isActive <>= try container.decode(Bool.self, forKey: .isActive)
        }
    }
}

// MARK: - Entity
extension Account: Entity {

    public static var primaryKey: String {
        return #keyPath(identifier)
    }
}

// MARK: - CodingKeys
extension Account {

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case iban
        case type
        case createdDate = "date_created"
        case isActive = "active"
    }
}
