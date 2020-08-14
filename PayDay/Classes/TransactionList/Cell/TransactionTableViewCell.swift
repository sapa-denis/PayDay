//
//  TransactionTableViewCell.swift
//  PayDay
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var iconView: UIView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconView.layer.cornerRadius = Constants.cornerRadius
    }

    // MARK: - Public methods
    func configure(with transaction: TransactionDisplayable) {
        dateLabel.text = transaction.dateFormatted
        descriptionLabel.text = transaction.vendorFormatted
        amountLabel.text = transaction.amountFormatted
    }
}
