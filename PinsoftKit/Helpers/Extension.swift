//
//  Extension.swift
//  PinsoftKit
//
//  Created by Onur Küçük on 29.04.2022.
//
import UIKit

extension UIWindow {
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }

    static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
    static var isPortrait: Bool {
            if #available(iOS 13.0, *) {
                return UIApplication.shared.keyWindow?.windowScene?.interfaceOrientation.isPortrait ?? false
                
                
//                return UIApplication.shared.windows
//                    .first?
//                    .windowScene?
//                    .interfaceOrientation
//                    .isPortrait ?? false
            } else {
                return UIApplication.shared.statusBarOrientation.isLandscape
            }
        }
}

extension UIApplication {
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}
