//
//  TransactionTableViewCell.swift
//  PayDay
//
//  Created by Sapa Denys on 12.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var iconView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconView.layer.cornerRadius = Constants.cornerRadius
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
