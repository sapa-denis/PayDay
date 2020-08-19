//
//  UITextField+Style.swift
//  PayDay
//
//  Created by Sapa Denys on 19.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

extension UITextField {
    
    func apply(style: TextFieldsStyle) {
        style.apply(for: self)
    }
}

enum TextFieldsStyle {
    case regular
    
    func apply(for textField: UITextField) {
        switch self {
        case .regular:
            let placeholder: String = textField.placeholder ?? ""
            let attributes: [NSAttributedString.Key: Any] = [
                            .foregroundColor: UIColor.placeholder,
                            .font: UIFont.general
            ]

            textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                                 attributes: attributes)
            
            textField.textColor = .black
            textField.font = .general
            textField.borderStyle = .roundedRect
            
            textField.layer.borderColor = UIColor.border.cgColor
            textField.layer.borderWidth = Constants.borderWidth
            textField.layer.cornerRadius = Constants.cornerRadius
        }
    }
}




