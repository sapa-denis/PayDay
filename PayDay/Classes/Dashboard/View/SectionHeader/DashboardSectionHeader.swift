//
//  DashboardSectionHeader.swift
//  PayDay
//
//  Created by Sapa Denys on 17.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

class DashboardSectionHeader: UITableViewHeaderFooterView {
    
    // MARK: - Static propertiess
    static let reuseIdentifier: String = String(describing: self)
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    // MARK: - Outlets
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var totalAmountLabel: UILabel!
    
    func configure(with month: String?, amount: String?) {
        monthLabel.text = month
        totalAmountLabel.text = amount
    }

}
