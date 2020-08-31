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

final class LoginViewController: UIViewController {

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

// MARK: - SwitchToLoginChainActionsHandler
extension LoginViewController: SignUpViewActionsDelegate {

    func onSwitchToLoginAction() {
        let viewController: UIViewController = pages[0]

        pageViewController.setViewControllers([viewController],
                                              direction: .reverse,
                                              animated: true)
    }
}

// MARK: - SwitchToLoginChainActionsHandler
extension LoginViewController: SignInViewActionsDelegate {

    func onSwitchToRegistrationAction() {
        let viewController: UIViewController

        if pages.count > 1 {
            viewController = pages[1]
        } else {
            viewController = appendSignUpViewController()
        }

        pageViewController.setViewControllers([viewController],
                                              direction: .forward,
                                              animated: true)
    }
}

// MARK: - SuccessLoginChainActionHandler
extension LoginViewController {

    func onSuccessLogin() {
        presenter.onSuccessLoginAction()
    }
}

// MARK: - Private methods
extension LoginViewController {

    private func setupContainerView() {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = self
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
        let initialViewController = SignInModule(with: self).viewController()
        pages.append(initialViewController)

        pageViewController.setViewControllers([initialViewController],
                                              direction: .forward,
                                              animated: false)
    }

    private func appendSignUpViewController() -> UIViewController {
        let viewController = SignUpModule(with: self).viewController()
        pages.append(viewController)

        return viewController
    }
}

// MARK: - UIPageViewControllerDataSource
extension LoginViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        switch viewController {
        case is SignUpViewController:
            return pages[0]
        default:
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        switch viewController {
        case is SignInViewController:
            if pages.count > 1 {
                return pages[1]
            } else {
                return appendSignUpViewController()
            }
        default:
            return nil
        }
    }
}
