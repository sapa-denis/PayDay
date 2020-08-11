//
//  User.swift
//  Entities
//
//  Created by Sapa Denys on 10.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import CoreData
import Core

@objc(User)
public final class User: NSManagedObject, Decodable {

    // MARK: - Properties
    @NSManaged public private(set) var identifier: Int64
    @NSManaged public private(set) var firstName: String
    @NSManaged public private(set) var lastName: String
    @NSManaged public private(set) var email: String
    @NSManaged public private(set) var password: String
    @NSManaged public private(set) var dob: String
    @NSManaged public private(set) var phone: String
    
    @NSManaged private var primitiveGender: String
    public private(set) var gender: Gender {
        get {
            defer {
                didAccessValue(forKey: "gender")
            }
            willAccessValue(forKey: "gender")
            
            return Gender(rawValue: primitiveGender) ?? .male
        }
        set {
            willChangeValue(forKey: "gender")
            primitiveGender = newValue.rawValue
            didChangeValue(forKey: "gender")
        }
    }
    
    // MARK: - Init / Deinit Methods
    required convenience public init(from decoder: Decoder) throws {
        guard let managedObjectContext = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: User.entityName, in: managedObjectContext) else {
                fatalError("Failed to decode \(User.self)")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        guard let container = try? decoder.container(keyedBy: CodingKeys.self),
            let identifier = try? container.decode(Int64.self, forKey: .identifier) else {
                managedObjectContext.delete(self)
                return
        }
        
        let object: User = (try? managedObjectContext.first(withPrimaryKey: identifier)) ?? self
        
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
            firstName <>= try container.decode(String.self, forKey: .firstName)
            lastName <>= try container.decode(String.self, forKey: .lastName)
            email <>= try container.decode(String.self, forKey: .email)
            password <>= try container.decode(String.self, forKey: .password)
            dob <>= try container.decode(String.self, forKey: .dob)
            phone <>= try container.decode(String.self, forKey: .phone)
        }
    }
}

// MARK: - Entity
extension User: Entity {
    
    public static var primaryKey: String {
        return #keyPath(identifier)
    }
}

// MARK: - External declaration
extension User {
    
    public enum Gender: String {
        case male
        case female
    }
}

// MARK: - CodingKeys
extension User {
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case firstName = "First Name"
        case lastName = "Last Name"
        case gender
        case email
        case password
        case dob
        case phone
    }
}
