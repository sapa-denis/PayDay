//
//  String+Email.swift
//  PayDay
//
//  Created by Sapa Denys on 11.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

extension String {

    var isEmail: Bool {
        return checkRegEx(for: self, regEx: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}")
    }

    private func checkRegEx(for string: String, regEx: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", regEx)
        return test.evaluate(with: string)
    }
}
