//
//  Transaction.swift
//  Entities
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import CoreData
import Core

@objc(Transaction)
public final class Transaction: NSManagedObject, Decodable {
    
    // MARK: - Properties
    @NSManaged public private(set) var identifier: Int64
    @NSManaged public private(set) var vendor: String
    @NSManaged public private(set) var category: String
    @NSManaged public private(set) var date: NSDate
    @NSManaged public private(set) var account: Account?
    
    @NSManaged private var primitiveAmount: NSDecimalNumber
    public private(set) var amount: Decimal {
        get {
            defer {
                didAccessValue(forKey: "gender")
            }
            willAccessValue(forKey: "gender")
            
            return primitiveAmount as Decimal
        }
        set {
            willChangeValue(forKey: "gender")
            primitiveAmount = newValue as NSDecimalNumber
            didChangeValue(forKey: "gender")
        }
    }
    
    @objc public var dateWithFormat: String? {
        let calendar = Calendar.current
        if calendar.isDateInToday(date as Date) {
           return "Today"
        } else if calendar.isDateInYesterday(date as Date) {
            return "Yesterday" 
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd, yyyy"
            return formatter.string(from: date as Date)
        }
    }
    
    @NSManaged public var executionPeriod: String
    
    // MARK: - Init / Deinit Methods
    required convenience public init(from decoder: Decoder) throws {
        guard let managedObjectContext = decoder.userInfo[CodingUserInfoKey.context] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: Transaction.entityName, in: managedObjectContext) else {
                fatalError("Failed to decode \(Transaction.self)")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        guard let container = try? decoder.container(keyedBy: CodingKeys.self),
            let identifier = try? container.decode(Int64.self, forKey: .identifier) else {
                managedObjectContext.delete(self)
                return
        }
        
        let object: Transaction = (try? managedObjectContext.first(withPrimaryKey: identifier)) ?? self
        
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
            
            let amountString = try container.decode(String.self, forKey: .amount)
            amount <>= (Decimal(string: amountString) ?? 0)
            
            vendor <>= try container.decode(String.self, forKey: .vendor)
            category <>= try container.decode(String.self, forKey: .category)
            let dateString = try container.decode(String.self, forKey: .date)
            let dateFormatter = ISO8601DateFormatter()
            date <>= dateFormatter.date(from:dateString)! as NSDate
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM, yyyy"
            executionPeriod <>= formatter.string(from: date as Date)
        }
    }
}

// MARK: - Entity
extension Transaction: Entity {
    
    public static var primaryKey: String {
        return #keyPath(identifier)
    }
}

// MARK: - CodingKeys
extension Transaction {
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case amount
        case vendor
        case category
        case date
    }
}
