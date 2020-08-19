//
//  UIScrollView+EndEditing.swift
//  PayDay
//
//  Created by Sapa Denys on 19.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    func addKeyboardDismissTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing(_:)))
        self.addGestureRecognizer(tapGesture)
    }
}
