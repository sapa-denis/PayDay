//
//  SignUpViewController.swift
//  PayDay
//
//  Created by Sapa Denys on 18.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

protocol SignUpView: AnyObject {
    
}

class SignUpViewController: UITableViewController {

    // MARK: - Properties
    var presenter: SignUpPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - SignUpView
extension SignUpViewController: SignUpView {
    
}
