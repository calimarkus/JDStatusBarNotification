//
//  NotificationPresenterLegacyOverlay.swift
//
//  Created by Markus Emrich on 10/15/23.
//  Copyright 2023 Markus Emrich. All rights reserved.
//

import Foundation
import UIKit

/// NOTE: These functions only exist for legacy objc compatibility.
/// You should not use them from Swift.
/// They do not offer any additional functionality over the existing Swift API.
///
/// For the curious, they start with the letter of z to show last in the auto-complete of swift code.
/// And they use abbreviated names, so that they don't show up for their names either.
public extension NotificationPresenter {


  // MARK: - Presentation (default style)

  /// Present a notification
  ///
  /// - Parameters:
  ///   - t: The text to display as title
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithText:)
  func zlp(t: String) -> UIView
  {
    present(t, subtitle: nil, styleName: nil, duration: nil, completion: nil)
  }

  /// Present a notification
  ///
  /// - Parameters:
  ///   - t: The text to display as title
  ///   - c: A ``Completion`` closure, which gets called once the presentation animation finishes. It won't be called after dismissal.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithText:completion:)
  func zlp(t: String, c: Completion?) -> UIView
  {
    present(t, subtitle: nil, styleName: nil, duration: nil, completion: c)
  }

  /// Present a notification
  ///
  /// - Parameters:
  ///   - t: The text to display as title
  ///   - c: A ``Completion`` closure, which gets called once the presentation animation finishes. It won't be called after dismissal.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithTitle:subtitle:completion:)
  func zlp(t: String, st: String, c: Completion?) -> UIView
  {
    present(t, subtitle: st, styleName: nil, duration: nil, completion: c)
  }

  /// Present a notification
  ///
  /// - Parameters:
  ///   - t: The text to display as title
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithText:dismissAfterDelay:)
  func zlp(t: String, d: Double) -> UIView
  {
    present(t, subtitle: nil, styleName: nil, duration: d, completion: nil)
  }


  // MARK: - Presentation (custom style)

  /// Present a notification using a custom style.
  ///
  /// - Parameters:
  ///   - t: The text to display as title
  ///   - cu: The name of the style. You can use styles previously added using e.g. ``addStyle(named:usingStyle:prepare:)``.
  ///                  If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithText:customStyle:)
  func zlp(t: String, cu: String) -> UIView
  {
    present(t, subtitle: nil, styleName: cu, duration: nil, completion: nil)
  }

  /// Present a notification using a custom style.
  ///
  /// - Parameters:
  ///   - t: The text to display as title
  ///   - cu: The name of the style. You can use styles previously added using e.g. ``addStyle(named:usingStyle:prepare:)``.
  ///                  If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithText:customStyle:completion:)
  func zlp(t: String, cu: String?, c: Completion?) -> UIView
  {
    present(t, subtitle: nil, styleName: cu, duration: nil, completion: c)
  }

  /// Present a notification using a custom style.
  ///
  /// - Parameters:
  ///   - t: The text to display as title
  ///   - st: The text to display as subtitle
  ///   - cu: The name of the style. You can use styles previously added using e.g. ``addStyle(named:usingStyle:prepare:)``.
  ///                If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///   - c: A ``Completion`` closure, which gets called once the presentation animation finishes. It won't be called after dismissal.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithTitle:subtitle:customStyle:completion:)
  func zlp(t: String,
           st: String?,
           cu: String?,
           c: Completion?) -> UIView
  {
    present(t, subtitle: st, styleName: cu, duration: nil, completion: c)
  }

  /// Present a notification using a custom style.
  ///
  /// - Parameters:
  ///   - t: The text to display as title
  ///   - cu: The name of the style. You can use styles previously added using e.g. ``addStyle(named:usingStyle:prepare:)``.
  ///                  If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithText:dismissAfterDelay:customStyle:)
  func zlp(t: String, d: Double, cu: String) -> UIView
  {
    present(t, subtitle: nil, styleName: cu, duration: d, completion: nil)
  }

  // MARK: - Presentation (included style)

  /// Present a notification using an included style.
  ///
  /// - Parameters:
  ///   - t: The text to display as title
  ///   - s: An existing ``IncludedStatusBarNotificationStyle``
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithText:includedStyle:)
  func zlp(t: String, s: IncludedStatusBarNotificationStyle) -> UIView
  {
    present(t, subtitle: nil, includedStyle: s, duration: nil, completion: nil)
  }

  /// Present a notification using an included style.
  ///
  /// - Parameters:
  ///   - t: The text to display as title
  ///   - s: An existing ``IncludedStatusBarNotificationStyle``
  ///   - c: A ``Completion`` closure, which gets called once the presentation animation finishes. It won't be called after dismissal.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithText:includedStyle:completion:)
  func zlp(t: String,
           s: IncludedStatusBarNotificationStyle,
           c: Completion?) -> UIView
  {
    present(t, subtitle: nil, includedStyle: s, duration: nil, completion: c)
  }

  /// Present a notification using an included style.
  ///
  /// - Parameters:
  ///   - t: The text to display as title
  ///   - st: The text to display as subtitle
  ///   - s: An existing ``IncludedStatusBarNotificationStyle``
  ///   - c: A ``Completion`` closure, which gets called once the presentation animation finishes. It won't be called after dismissal.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithTitle:subtitle:includedStyle:completion:)
  func zlp(t: String,
           st: String?,
           s: IncludedStatusBarNotificationStyle,
           c: Completion?) -> UIView
  {
    present(t, subtitle: st, includedStyle: s, duration: nil, completion: c)
  }

  /// Present a notification using an included style.
  ///
  /// - Parameters:
  ///   - t: The text to display as title
  ///   - d: The duration defines how long the notification will be visible. If not provided the notifcation will never be dismissed.
  ///   - s: An existing ``IncludedStatusBarNotificationStyle``
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithText:dismissAfterDelay:includedStyle:)
  func zlp(t: String,
           d: Double = 0.0,
           s: IncludedStatusBarNotificationStyle) -> UIView
  {
    present(t, subtitle: nil, includedStyle: s, duration: d, completion: nil)
  }

  // MARK: - Custom View

  /// Present a notification using a custom subview.
  ///
  /// The `customView` will be layouted correctly according to the selected style & the current device
  /// state (rotation, status bar visibility, etc.). The background will still be styled & layouted
  /// according to the provided style. If your custom view requires custom touch handling,
  /// make sure to set `style.canTapToHold` to `false`. Otherwise the `customView` won't
  /// receive any touches, as the internal `gestureRecognizer` would receive them.
  ///
  /// - Parameters:
  ///   - cv: A custom UIView to display as notification content.
  ///   - s: The name of the style. You can use styles previously added using e.g. ``addStyle(named:usingStyle:prepare:)``.
  ///                If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///   - c: A ``Completion`` closure, which gets called once the presentation animation finishes.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithCustomView:styleName:completion:)
  func zlp(cv: UIView,
           s: String? = nil,
           c: Completion? = nil) -> UIView
  {
    return presentCustomView(cv, sizingController: nil, styleName: s, completion: c)
  }

  // MARK: - Dismissal

  /// Dismisses the displayed notification.
  @objc(dismiss)
  func zld() {
    dismiss(animated: true, after: 0.0, completion: nil)
  }

  /// Dismisses the displayed notification.
  ///
  /// - Parameters:
  ///   - c: A ``Completion`` closure, which gets called once the dismiss animation finishes.
  @objc(dismissWithCompletion:)
  func zld(c: Completion?) {
    dismiss(animated: true, after: 0.0, completion: c)
  }

  /// Dismisses the displayed notification.
  ///
  /// - Parameters:
  ///   - a: If `true`, the notification will be dismissed animated according to the currently set ``StatusBarNotificationAnimationType``.
  ///   Otherwise it will be dismissed without animation.
  @objc(dismissAnimated:)
  func zld(a: Bool) {
    dismiss(animated: a, after: 0.0, completion: nil)
  }

  /// Dismisses the displayed notification after the provided delay.
  ///
  /// - Parameters:
  ///   - d: The delay in seconds, before the notification should be dismissed.
  @objc(dismissAfterDelay:)
  func zld(d: Double) {
    dismiss(animated: true, after: d, completion: nil)
  }

  /// Dismisses the displayed notification after the provided delay.
  ///
  /// - Parameters:
  ///   - d: The delay in seconds, before the notification should be dismissed.
  ///   - c: A ``Completion`` closure, which gets called once the dismiss animation finishes.
  @objc(dismissAfterDelay:completion:)
  func zld(d: Double, c: Completion?) {
    dismiss(animated: true, after: d, completion: c)
  }

  /// Dismisses the displayed notification after the provided delay.
  ///
  /// - Parameters:
  ///   - a: If `true`, the notification will be dismissed animated according to the currently set ``StatusBarNotificationAnimationType``.
  ///   Otherwise it will be dismissed without animation.   
  ///   - d: The delay in seconds, before the notification should be dismissed.
  ///   - c: A ``Completion`` closure, which gets called once the dismiss animation finishes.
  @objc(dismissAnimated:afterDelay:completion:)
  func zld(a: Bool, d: Double, c: Completion?) {
    dismiss(animated: a, after: d, completion: c)
  }

  // MARK: - Style Customization

  /// Adds a new named style, which can later be used by referencing it using the `styleName`.
  ///
  /// The added style can be used in future presentations by utilizing the same `styleName` in e.g. ``present(_:subtitle:styleName:duration:completion:)``.
  /// If a style with the same name already exists, it will be replaced.
  ///
  /// - Parameters:
  ///   - n:  The styleName which will later be used to reference the added style.
  ///   - p: Provides an ``StatusBarNotificationStyle`` instance based on the provided `includedStyle` for further customization.
  ///
  /// - Returns: Returns the `styleName`, so that this call can be used directly within a presentation call.
  ///
  @discardableResult
  @objc(addStyleNamed:prepare:)
  func zlas(n: String, p: PrepareStyleClosure) -> String {
    return addStyle(named: n, usingStyle: .defaultStyle, prepare: p)
  }
}
