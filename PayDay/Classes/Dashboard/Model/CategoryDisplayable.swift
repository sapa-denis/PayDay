//
//  CategoryDisplayable.swift
//  PayDay
//
//  Created by Sapa Denys on 17.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Features

protocol CategoryDisplayable {
    var name: String { get }
    var formattedAmount: String? { get }
}

extension DashboardRepository.CategoryInfo: CategoryDisplayable {

    var formattedAmount: String? {
        amount.usStringMoney
    }
}
