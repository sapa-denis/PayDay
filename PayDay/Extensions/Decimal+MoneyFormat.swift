//
//  Decimal+MoneyFormat.swift
//  PayDay
//
//  Created by Sapa Denys on 20.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

extension Decimal {
    var usStringMoney: String? {
        return NumberFormatter.usFormatWithSeparator().string(for: self)
    }
}

extension NumberFormatter {

    static func usFormatWithSeparator() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.roundingMode = .up
        return formatter
    }
}
