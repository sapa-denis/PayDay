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
    private var loginOperation: NetworkOperation!
    
    // MARK: - Init / Deinit methods
    init(with view: LoginView) {
        self.view = view
    }
    
    // MARK: - Public methods
    func loginAction(email: String, password: String) {
        
        
        loginOperation = NetworkOperation(in: .networking,
                                          session: .main,
                                          request: AuthenticationRequest.authenticate(email: email,
                                                                                      password: password))
        loginOperation.completed = { [weak loginOperation] in
            switch loginOperation?.output {
            case .success(let data):
                print(String(data: data, encoding: .utf8)!)
            default:
                return
            }
        }
        
        loginOperation.start()
    }
}
