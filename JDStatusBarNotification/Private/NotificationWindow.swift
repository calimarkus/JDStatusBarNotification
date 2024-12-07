//
//  NotificationWindow.swift
//  JDStatusBarNotification
//
//  Created by Markus on 11/12/23.
//  Copyright © 2023 Markus. All rights reserved.
//

import Foundation
import UIKit

class NotificationWindow: UIWindow {
  let statusBarViewController: NotificationViewController

  init(windowScene: UIWindowScene?,
       delegate: NotificationPresentationDelegate)
  {

    let statusBarViewController = NotificationViewController()
    self.statusBarViewController = statusBarViewController

    // attempt to infer window scene
    var windowSceneToUse = windowScene
    if windowScene == nil {
      windowSceneToUse = DiscoveryHelper.discoverMainWindowScene()
    }

    if let windowSceneToUse {
      super.init(windowScene: windowSceneToUse)
    } else {
      super.init(frame: UIScreen.main.bounds)
    }

    statusBarViewController.delegate = delegate
    statusBarViewController.jdsb_window = self
    rootViewController = statusBarViewController

    autoresizingMask = [.flexibleWidth, .flexibleHeight]
    backgroundColor = .clear
    isUserInteractionEnabled = true
    windowLevel = .statusBar
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - HitTest

  public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let topBar = statusBarViewController.statusBarView
    if topBar.isUserInteractionEnabled {
      return topBar.hitTest(convert(point, to: topBar), with: event)
    }
    return nil;
  }
}
