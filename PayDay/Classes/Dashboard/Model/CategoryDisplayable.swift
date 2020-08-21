//
//  CategoryDisplayable.swift
//  PayDay
//
//  Created by Sapa Denys on 17.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

struct CategoryDisplayable {

    // MARK: - Properties
    let name: String
    var formattedAmount: String? {
        amount.usStringMoney
    }

    private let amount: Decimal

    // MARL: - Init / Deinitmethods
    init(name: String, amount: Decimal) {
        self.name = name
        self.amount = amount
    }
}
