//
//  KeyboardHandler.swift
//  PayDay
//
//  Created by Sapa Denys on 19.08.2020.
//  Copyright © 2020 Sapa Denys. All rights reserved.
//

import UIKit

final class KeyboardHandler {

    let scrollView: UIScrollView
    let offset: CGFloat
    var tokens: [Any] = []

    init(scrollView: UIScrollView, offset: CGFloat = 0) {
        self.scrollView = scrollView
        self.offset = offset

        handleKeyboard()
    }

    func handleKeyboard() {
        weak var weakSelf = self

        var token = NotificationCenter
            .default
            .addObserver(forName: UIWindow.keyboardWillShowNotification,
                         object: nil,
                         queue: nil) { notif in
                            weakSelf?.keyboardWillShow(notif)
        }
        tokens.append(token)

        token = NotificationCenter
            .default
            .addObserver(forName: UIWindow.keyboardWillChangeFrameNotification,
                         object: nil,
                         queue: nil) { notif in
                            weakSelf?.keyboardWillShow(notif)
        }
        tokens.append(token)

        token = NotificationCenter
            .default
            .addObserver(forName: UIWindow.keyboardWillHideNotification,
                         object: nil,
                         queue: nil) { notif in
                            weakSelf?.keyboardWillHide(notif)
        }
        tokens.append(token)
    }

    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }

    func keyboardWillShow(_ notification: Notification) {
        let keyboardInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject
        guard let keyboardFrame = keyboardInfo.cgRectValue,
            let superview = scrollView.superview else {
                return
        }

        let keyboardSize = superview.convert(keyboardFrame, from: nil).size
        let contentInset = UIEdgeInsets(top: scrollView.contentInset.top,
                                        left: 0,
                                        bottom: keyboardSize.height - offset,
                                        right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }

    func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}
