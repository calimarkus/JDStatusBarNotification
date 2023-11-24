//
//  NotificationPresenterLegacyOverlay.swift
//
//  Created by Markus Emrich on 10/15/23.
//  Copyright 2023 Markus Emrich. All rights reserved.
//

import Foundation
import UIKit

public extension NotificationPresenter {


  // MARK: - Presentation (default style)

  /// Present a notification
  ///
  /// - Parameters:
  ///   - text: The text to display as title
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithText:)
  func present(_ text: String) -> UIView
  {
    present(text, subtitle: nil, styleName: nil, duration: 0.0, completion: nil)
  }

  /// Present a notification
  ///
  /// - Parameters:
  ///   - text: The text to display as title
  ///   - completion: A ``Completion`` closure, which gets called once the presentation animation finishes. It won't be called after dismissal.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithText:completion:)
  func present(_ text: String, completion: Completion?) -> UIView
  {
    present(text, subtitle: nil, styleName: nil, duration: 0.0, completion: completion)
  }

  /// Present a notification
  ///
  /// - Parameters:
  ///   - text: The text to display as title
  ///   - completion: A ``Completion`` closure, which gets called once the presentation animation finishes. It won't be called after dismissal.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithTitle:subtitle:completion:)
  func present(_ title: String, subtitle: String, completion: Completion?) -> UIView
  {
    present(title, subtitle: subtitle, styleName: nil, duration: 0.0, completion: completion)
  }

  /// Present a notification
  ///
  /// - Parameters:
  ///   - text: The text to display as title
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithText:dismissAfterDelay:)
  func present(_ text: String, delay: CGFloat) -> UIView
  {
    present(text, subtitle: nil, styleName: nil, duration: delay, completion: nil)
  }


  // MARK: - Presentation (custom style)

  /// Present a notification using the default style or a named style.
  ///
  /// - Parameters:
  ///   - text: The text to display as title
  ///   - customStyle: The name of the style. You can use styles previously added using e.g. ``addStyle(named:usingStyle:prepare:)``.
  ///                  If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithText:customStyle:)
  func present(_ text: String, customStyle: String) -> UIView
  {
    present(text, subtitle: nil, styleName: customStyle, duration: 0.0, completion: nil)
  }

  /// Present a notification using the default style or a named style.
  ///
  /// - Parameters:
  ///   - text: The text to display as title
  ///   - customStyle: The name of the style. You can use styles previously added using e.g. ``addStyle(named:usingStyle:prepare:)``.
  ///                  If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithText:customStyle:completion:)
  func present(_ text: String, customStyle: String?, completion: Completion?) -> UIView
  {
    present(text, subtitle: nil, styleName: customStyle, duration: 0.0, completion: completion)
  }

  /// Present a notification using the default style or a named style.
  ///
  /// - Parameters:
  ///   - title: The text to display as title
  ///   - subtitle: The text to display as subtitle
  ///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyle(named:usingStyle:prepare:)``.
  ///                If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///   - completion: A ``Completion`` closure, which gets called once the presentation animation finishes. It won't be called after dismissal.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithTitle:subtitle:customStyle:completion:)
  func present(_ title: String,
               subtitle: String?,
               customStyle: String?,
               completion: Completion?) -> UIView
  {
    present(title, subtitle: subtitle, styleName: customStyle, duration: 0.0, completion: completion)
  }

  /// Present a notification using the default style or a named style.
  ///
  /// - Parameters:
  ///   - text: The text to display as title
  ///   - customStyle: The name of the style. You can use styles previously added using e.g. ``addStyle(named:usingStyle:prepare:)``.
  ///                  If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithText:dismissAfterDelay:customStyle:)
  func present(_ text: String, delay: CGFloat, customStyle: String) -> UIView
  {
    present(text, subtitle: nil, styleName: customStyle, duration: delay, completion: nil)
  }

  // MARK: - Presentation (included style)

  /// Present a notification using an included style.
  ///
  /// - Parameters:
  ///   - text: The text to display as title
  ///   - includedStyle: An existing ``IncludedStatusBarNotificationStyle``
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithText:includedStyle:)
  func present(_ text: String, includedStyle: IncludedStatusBarNotificationStyle) -> UIView
  {
    present(text, subtitle: nil, includedStyle: includedStyle, duration: 0.0, completion: nil)
  }

  /// Present a notification using an included style.
  ///
  /// - Parameters:
  ///   - text: The text to display as title
  ///   - includedStyle: An existing ``IncludedStatusBarNotificationStyle``
  ///   - completion: A ``Completion`` closure, which gets called once the presentation animation finishes. It won't be called after dismissal.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithText:includedStyle:completion:)
  func present(_ text: String,
               includedStyle: IncludedStatusBarNotificationStyle,
               completion: Completion?) -> UIView
  {
    present(text, subtitle: nil, includedStyle: includedStyle, duration: 0.0, completion: completion)
  }

  /// Present a notification using an included style.
  ///
  /// - Parameters:
  ///   - title: The text to display as title
  ///   - subtitle: The text to display as subtitle
  ///   - includedStyle: An existing ``IncludedStatusBarNotificationStyle``
  ///   - completion: A ``Completion`` closure, which gets called once the presentation animation finishes. It won't be called after dismissal.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithTitle:subtitle:includedStyle:completion:)
  func present(_ title: String,
               subtitle: String?,
               includedStyle: IncludedStatusBarNotificationStyle,
               completion: Completion?) -> UIView
  {
    present(title, subtitle: subtitle, includedStyle: includedStyle, duration: 0.0, completion: completion)
  }

  /// Present a notification using an included style.
  ///
  /// - Parameters:
  ///   - text: The text to display as title
  ///   - duration: The duration defines how long the notification will be visible. If not provided the notifcation will never be dismissed.
  ///   - includedStyle: An existing ``IncludedStatusBarNotificationStyle``
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithText:dismissAfterDelay:includedStyle:)
  func present(_ text: String,
               delay: CGFloat = 0.0,
               includedStyle: IncludedStatusBarNotificationStyle) -> UIView
  {
    present(text, subtitle: nil, includedStyle: includedStyle, duration: delay, completion: nil)
  }

  // MARK: - Dismissal

  /// Dismisses any currently displayed notification animated - after the provided delay, if provided.
  @objc
  func dismiss() {
    dismiss(animated: true, after: 0.0, completion: nil)
  }

  /// Dismisses any currently displayed notification animated - after the provided delay, if provided.
  ///
  /// - Parameters:
  ///   - completion: A ``Completion`` closure, which gets called once the dismiss animation finishes.
  @objc(dismissWithCompletion:)
  func dismiss(completion: Completion?) {
    dismiss(animated: true, after: 0.0, completion: completion)
  }

  /// Dismisses any currently displayed notification animated - after the provided delay, if provided.
  ///
  /// - Parameters:
  ///   - animated: If `true`, the notification will be dismissed animated according to the currently set ``StatusBarNotificationAnimationType``.
  ///   Otherwise it will be dismissed without animation.
  @objc(dismissAnimated:)
  func dismiss(animated: Bool) {
    dismiss(animated: animated, after: 0.0, completion: nil)
  }

  /// Dismisses any currently displayed notification animated - after the provided delay, if provided.
  ///
  /// - Parameters:
  ///   - delay: The delay in seconds, before the notification should be dismissed.
  @objc(dismissAfterDelay:)
  func dismiss(after delay: CGFloat) {
    dismiss(animated: true, after: delay, completion: nil)
  }

  /// Dismisses any currently displayed notification animated - after the provided delay, if provided.
  ///
  /// - Parameters:
  ///   - delay: The delay in seconds, before the notification should be dismissed.
  ///   - completion: A ``Completion`` closure, which gets called once the dismiss animation finishes.
  @objc(dismissAfterDelay:completion:)
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
  func addStyle(named name: String, prepare: PrepareStyleClosure) -> String {
    return addStyle(named: name, usingStyle: .defaultStyle, prepare: prepare)
  }
}
