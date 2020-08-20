//
//  DashboardTableViewCell.swift
//  PayDay
//
//  Created by Sapa Denys on 17.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var iconView: UIView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconView.layer.cornerRadius = Constants.cornerRadius
    }

    // MARK: - Public methods
    func configure(with category: CategoryDisplayable) {
        descriptionLabel.text = category.name
        amountLabel.text = category.formattedAmount
    }
}
