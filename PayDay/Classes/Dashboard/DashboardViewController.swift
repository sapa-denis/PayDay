//
//  DashboardViewController.swift
//  PayDay
//
//  Created by Sapa Denys on 16.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

protocol DashboardView: AnyObject {
    
}

class DashboardViewController: UIViewController {

    // MARK: - Outlets
    
    // MARK: - Properties
    var presenter: DashboardPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Monthly Dashboard"
    }
}

extension DashboardViewController: DashboardView {
    
}
