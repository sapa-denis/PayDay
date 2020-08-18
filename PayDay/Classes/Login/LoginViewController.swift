//
//  LoginViewController.swift
//  PayDay
//
//  Created by Sapa Denys on 18.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

protocol LoginView: AnyObject {
    
}

class LoginViewController: UIViewController {

    // MARK: - Properties
    var presenter: LoginPresenter!
    
    private var pageViewController: UIPageViewController!
    private var pages: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContainerView()
    }
}

// MARK: - LoginView
extension LoginViewController: LoginView {
    
}

// MARK: - Private methods
extension LoginViewController {
    
    private func setupContainerView() {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = self
//        pageViewController.delegate = self
        guard let pageView = pageViewController.view else {
            return
        }
        
        view.addSubview(pageView)
        pageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([pageView.topAnchor.constraint(equalTo: view.topAnchor),
                                     pageView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                     pageView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                     pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        self.pageViewController = pageViewController
        addChild(pageViewController)
        pageViewController.willMove(toParent: self)
        setFirstViewController()
    }
    
    private func setFirstViewController() {
        let initialViewController = SignUpModule().viewController()
        pages.append(initialViewController)
        
        pageViewController.setViewControllers([initialViewController],
                                              direction: .forward,
                                              animated: false)
    }
}

// MARK: - UIPageViewControllerDataSource
extension LoginViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        switch viewController {
        case is SignInViewController:
            return pages[0]
        default:
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        switch viewController {
        case is SignUpViewController:
            if pages.count > 1 {
                return pages[1]
            } else {
                let viewController = SignInModule().viewController()
                pages.append(viewController)
                
                return viewController
            }
        default:
            return nil
        }
    }
}

//extension LoginViewController: UIPageViewControllerDelegate {
//
//    func pageViewController(_ pageViewController: UIPageViewController,
//                            didFinishAnimating finished: Bool,
//                            previousViewControllers: [UIViewController],
//                            transitionCompleted completed: Bool) {
//
//    }
//}
