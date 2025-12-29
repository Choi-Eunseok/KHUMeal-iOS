//
//  UIViewController.swift
//  Meal
//

import UIKit

#if DEBUG
extension UIViewController {
    @objc func injected() {
        self.viewDidLoad()
    }
}
#endif
