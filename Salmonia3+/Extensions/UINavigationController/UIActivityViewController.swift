//
//  UIActivityViewController.swift
//  Salmonia3+
//
//  Created by devonly on 2022/11/17.
//

import Foundation
import UIKit

extension UIViewController {
    func popover(_ viewControllerToPresent: UIActivityViewController, animated: Bool) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popover = viewControllerToPresent.popoverPresentationController {
                popover.sourceView = viewControllerToPresent.view
                popover.barButtonItem = .none
                popover.sourceRect = viewControllerToPresent.accessibilityFrame
            }
        }
        self.present(viewControllerToPresent, animated: animated)
    }
}
