//
//  UIApplication+Windows.swift
//  JDStatusBarNotification
//
//  Created by Markus on 11/12/23.
//  Copyright © 2023 Markus. All rights reserved.
//

import Foundation
import UIKit

@objc
public extension UIApplication {

  func jdsb_mainApplicationWindowIgnoringWindow(_ ignoringWindow: UIWindow? = nil) -> UIWindow? {
    var allWindows: [UIWindow];
    if let ignoringWindow, let windowScene = ignoringWindow.windowScene {
      allWindows = windowScene.windows;
    } else {
      allWindows = UIApplication.shared.windows;
    }
    
    for window in allWindows {
      if (!window.isHidden && window != ignoringWindow) {
        return window;
      }
    }
    return nil;
  }

  func jdsb_mainControllerIgnoringViewController(_ viewController: UIViewController) -> UIViewController? {
    let mainAppWindow = jdsb_mainApplicationWindowIgnoringWindow(viewController.view.window);
    guard let mainAppWindow else { return nil }

    var topController = mainAppWindow.rootViewController;
    guard let _ = topController else { return nil }

    while let presentedViewController = topController?.presentedViewController {
      topController = presentedViewController;
    }

    if let tc = topController, tc.responds(to: #selector(getter: UINavigationController.topViewController)) {
      topController = (topController as? UINavigationController)?.topViewController;
    }

    // ensure we never end up with recursive calls
    return (topController == viewController) ? nil : topController;
  }
}
