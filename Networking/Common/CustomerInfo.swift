//
//  CustomerInfo.swift
//  Networking
//
//  Created by Sapa Denys on 21.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

public struct CustomerInfo: Encodable {

    let firstName: String
    let lastName: String
    let gender: String
    let email: String
    let password: String
    let dateOfBirth: String
    let phone: String

    public init(firstName: String,
                lastName: String,
                gender: String,
                email: String,
                password: String,
                dateOfBirth: String,
                phone: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.email = email
        self.password = password
        self.dateOfBirth = dateOfBirth
        self.phone = phone
    }

    enum CodingKeys: String, CodingKey {
        case firstName = "First Name"
        case lastName = "Last Name"
        case email
        case phone
        case password
        case gender
        case dateOfBirth = "dob"
    }
}
