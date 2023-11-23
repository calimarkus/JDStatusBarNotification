//
//  NotificationPresenterOverlay.swift
//
//  Created by Markus Emrich on 10/15/23.
//  Copyright 2023 Markus Emrich. All rights reserved.
//

import Foundation
import UIKit

public extension NotificationPresenter {

  // MARK: - Dismissal

  /// Dismisses any currently displayed notification animated - after the provided delay, if provided.
  @objc
  @available(*, unavailable)
  func dismiss() {
    dismiss(animated: true)
  }

  /// Dismisses any currently displayed notification animated - after the provided delay, if provided.
  ///
  /// - Parameters:
  ///   - completion: A ``Completion`` closure, which gets called once the dismiss animation finishes.
  @objc(dismissWithCompletion:)
  @available(*, unavailable)
  func dismiss(completion: Completion?) {
    dismiss(animated: true, completion: completion)
  }

  /// Dismisses any currently displayed notification animated - after the provided delay, if provided.
  ///
  /// - Parameters:
  ///   - animated: If `true`, the notification will be dismissed animated according to the currently set ``StatusBarNotificationAnimationType``.
  ///   Otherwise it will be dismissed without animation.
  @objc(dismissAnimated:)
  @available(*, unavailable)
  func dismiss(animated: Bool) {
    dismiss(animated: animated)
  }

  /// Dismisses any currently displayed notification animated - after the provided delay, if provided.
  ///
  /// - Parameters:
  ///   - delay: The delay in seconds, before the notification should be dismissed.
  @objc(dismissAfterDelay:)
  @available(*, unavailable)
  func dismiss(after delay: CGFloat) {
    dismiss(animated: true, after: delay)
  }

  /// Dismisses any currently displayed notification animated - after the provided delay, if provided.
  ///
  /// - Parameters:
  ///   - delay: The delay in seconds, before the notification should be dismissed.
  ///   - completion: A ``Completion`` closure, which gets called once the dismiss animation finishes.
  @objc(dismissAfterDelay:completion:)
  @available(*, unavailable)
  func dismiss(after delay: CGFloat, completion: Completion?) {
    dismiss(animated: true, after: delay, completion: completion)
  }

  // MARK: - Style Customization

  /// Adds a new named style - based on an included style, if given.
  /// This can later be used by referencing it using the `styleName` - or by using the return value directly.
  ///
  /// The added style can be used in future presentations by utilizing the same `styleName` in e.g. ``present(_:subtitle:styleName:duration:completion:)``.
  /// If a style with the same name already exists, it will be replaced.
  ///
  /// - Parameters:
  ///   - name:  The styleName which will later be used to reference the added style.
  ///   - prepare: Provides an ``StatusBarNotificationStyle`` instance based on the provided `includedStyle` for further customization.
  ///
  /// - Returns: Returns the `styleName`, so that this call can be used directly within a presentation call.
  ///
  @discardableResult
  @objc(addStyleNamed:prepare:)
  @available(*, unavailable)
  func addStyle(named name: String, prepare: PrepareStyleClosure) -> String {
    return addStyle(named: name, usingStyle: .defaultStyle, prepare: prepare)
  }
}
