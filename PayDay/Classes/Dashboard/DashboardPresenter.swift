//
//  DashboardPresenter.swift
//  PayDay
//
//  Created by Sapa Denys on 16.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

final class DashboardPresenter {
    
    // MARK: - Properties
    private weak var view: DashboardView!
    
    init(with view: DashboardView) {
        self.view = view
    }
}
