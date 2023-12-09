//
//  DiscoveryHelper.swift
//  JDStatusBarNotification
//
//  Created by Markus on 11/12/23.
//  Copyright © 2023 Markus. All rights reserved.
//

import Foundation
import UIKit

enum DiscoveryHelper {

  static func discoverMainWindowScene() -> UIWindowScene? {
    return discoverMainWindow()?.windowScene
  }

  static func discoverMainWindow(ignoring ignoredWindow: UIWindow? = nil) -> UIWindow? {
    var allWindows: [UIWindow];
    if let ignoredWindow, let windowScene = ignoredWindow.windowScene {
      allWindows = windowScene.windows;
    } else {
      allWindows = UIApplication.shared.windows;
    }
    
    for window in allWindows {
      if (!window.isHidden && window != ignoredWindow) {
        return window;
      }
    }
    return nil;
  }

  static func discoverMainViewController(ignoring viewController: UIViewController) -> UIViewController? {
    let mainAppWindow = discoverMainWindow(ignoring: viewController.view.window);
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
