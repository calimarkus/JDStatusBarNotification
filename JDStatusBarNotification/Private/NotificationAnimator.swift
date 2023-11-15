//
//  NotificationAnimator.swift
//  JDStatusBarNotification
//
//  Created by Markus on 11/12/23.
//  Copyright © 2023 Markus. All rights reserved.
//

import Foundation
import UIKit

class JDSBNotificationAnimator: NSObject, CAAnimationDelegate {

  private let statusBarView: NotificationView
  private var animateInCompletionBlock: (() -> Void)? = nil

  init(statusBarView: NotificationView) {
    self.statusBarView = statusBarView
    super.init()
  }

  func animateIn(for duration: Double, completion: (() -> Void)?) {
    let view = statusBarView

    animateInCompletionBlock = nil
    view.layer.removeAllAnimations()

    if view.style.animationType == .fade {
      view.alpha = 0.0
      view.transform = CGAffineTransform.identity
    } else {
      view.alpha = 1.0
      view.transform = CGAffineTransform(translationX: 0, y: -view.bounds.height)
    }

    if view.style.animationType == .bounce {
      animateInCompletionBlock = completion
      animateInWithBounceAnimation(statusBarView: view, delegate: self)
    } else {
      UIView.animate(withDuration: duration, animations: {
        view.alpha = 1.0
        view.transform = .identity
      }) { finished in
        if finished, let completion {
          completion()
        }
      }
    }
  }

  private func animateInWithBounceAnimation(statusBarView: NotificationView, delegate: CAAnimationDelegate) {
    func RBBEasingFunctionEaseOutBounce(_ t: Double) -> Double {
      if t < 4.0 / 11.0 {
        return pow(11.0 / 4.0, 2) * pow(t, 2)
      } else if t < 8.0 / 11.0 {
        return 3.0 / 4.0 + pow(11.0 / 4.0, 2) * pow(t - 6.0 / 11.0, 2)
      } else if t < 10.0 / 11.0 {
        return 15.0 / 16.0 + pow(11.0 / 4.0, 2) * pow(t - 9.0 / 11.0, 2)
      } else {
        return 63.0 / 64.0 + pow(11.0 / 4.0, 2) * pow(t - 21.0 / 22.0, 2)
      }
    }

    let animationSteps = 200
    let fromCenterY: Double = -Double(statusBarView.bounds.height)
    let toCenterY: Double = 0

    var values = [CATransform3D]()
    for t in 1 ... animationSteps {
      let easedTime = RBBEasingFunctionEaseOutBounce(Double(t) / Double(animationSteps))
      let easedValue = fromCenterY + easedTime * (toCenterY - fromCenterY)
      values.append(CATransform3DMakeTranslation(0, CGFloat(easedValue), 0))
    }

    let keyPath = "transform"
    let animation = CAKeyframeAnimation(keyPath: keyPath)
    animation.timingFunction = CAMediaTimingFunction(name: .linear)
    animation.duration = 0.75
    animation.values = values
    animation.isRemovedOnCompletion = false
    animation.fillMode = .forwards
    animation.delegate = delegate
    statusBarView.layer.setValue(toCenterY, forKeyPath: keyPath)
    statusBarView.layer.add(animation, forKey: "JDBounceAnimation")
  }

  func animateOut(for duration: Double, completion: (() -> Void)?) {
    let view = statusBarView

    UIView.animate(withDuration: duration, animations: {
      if view.style.animationType == .fade {
        view.alpha = 0.0
      } else {
        view.transform = CGAffineTransform(translationX: 0, y: -view.bounds.height)
      }
    }) { finished in
      if finished, let completion {
        completion()
      }
    }
  }

  // MARK: - CAAnimationDelegate

  func animationDidStop(_ anim: CAAnimation, finished: Bool) {
    if finished {
      statusBarView.transform = CGAffineTransform.identity
      statusBarView.layer.removeAllAnimations()

      let completion = animateInCompletionBlock
      animateInCompletionBlock = nil
      completion?()
    }
  }
}
