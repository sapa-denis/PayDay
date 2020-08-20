//
//  TransactionDisplayable.swift
//  PayDay
//
//  Created by Sapa Denys on 14.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation
import Entities

protocol TransactionDisplayable {
    var dateFormatted: String { get }
    var vendorFormatted: String { get }
    var amountFormatted: String { get }
}

extension Transaction: TransactionDisplayable {
    
    var dateFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date as Date)
    }
    
    var amountFormatted: String {
        amount.usStringMoney ?? ""
    }
    
    var vendorFormatted: String {
        vendor
    }
}
