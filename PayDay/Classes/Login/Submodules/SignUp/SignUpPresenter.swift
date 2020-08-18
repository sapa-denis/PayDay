//
//  SignUpPresenter.swift
//  PayDay
//
//  Created by Sapa Denys on 18.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation

final class SignUpPresenter {
    
    // MARK: - Properties
    private weak var view: SignUpView!
    
    // MARK: - Init/Deinit methods
    init(with view: SignUpView) {
        self.view = view
    }
}
