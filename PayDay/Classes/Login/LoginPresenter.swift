//
//  LoginPresenter.swift
//  PayDay
//
//  Created by Sapa Denys on 06.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import Foundation
import Networking

final class LoginPresenter {

    // MARK: - Properties
    private weak var view: LoginView!
    private lazy var loginOperation: NetworkOperation = {
        let request = URLRequest(url: URL(string: "")!)
        return NetworkOperation(in: .networking, session: .main, request: request)
    }()
    
    // MARK: - Init / Deinit methods
    init(with view: LoginView) {
        self.view = view
    }
    
    // MARK: - Public methods
    func loginAction(email: String, password: String) {
        
        
    }
}
