//
//  NotificationPresenter.swift
//
//  Created by Markus Emrich on 10/15/23.
//  Copyright 2023 Markus Emrich. All rights reserved.
//

import SwiftUI

/**
 * The NotificationPresenter let's you present notifications below the statusBar.
 * You can customize the style (colors, fonts, etc.) and animations. It supports notch
 * and no-notch devices, landscape & portrait layouts and Drag-to-Dismiss. It can display a
 * title, a subtitle, an activity indicator, an animated progress bar & custom views out of the box.
 *
 * To customize the appearance, see the *Customize the style* section. To see all customization
 * options, see the ``StatusBarNotificationStyle`` documentation.
 *
 * While a notification is displayed, a separate window is presented on top of your application
 * window. Upon dismissal this window, its view controller and all its views are removed from
 * memory. The presenter class itself is a singleton which will stay in memory for the lifetime of
 * your application once it was created. The default ``StatusBarNotificationStyle`` and any styles
 * added by the user also stay in memory permanently.
 */
@objc(JDStatusBarNotificationPresenter)
public class NotificationPresenter: NSObject, NotificationWindowDelegate {

  var overlayWindow: NotificationWindow?
  var styleCache: StyleCache

  /// Provides access to the shared presenter. This is the entry point to present, style and dismiss notifications.
  ///
  /// - Returns: An initialized ``NotificationPresenter`` instance.
  @objc(sharedPresenter)
  public private(set) static var shared = NotificationPresenter()

  private override init() {
    styleCache = StyleCache()
  }

  /// Called upon animation completion.
  ///
  /// - Parameter presenter: Provides the shared ``NotificationPresenter`` instance. That simplifies any subsequent calls to it upon completion.
  ///
  public typealias Completion = (_ presenter : NotificationPresenter) -> ()

  /// Creates a modified copy of an existing ``StatusBarNotificationStyle`` instance.
  ///
  /// - Parameter style: The current default ``StatusBarNotificationStyle`` instance.
  ///
  /// - Returns: The modified ``StatusBarNotificationStyle`` instance.
  ///
  public typealias PrepareStyleClosure = (StatusBarNotificationStyle) -> StatusBarNotificationStyle

  fileprivate func present(_ title: String?,
                           subtitle: String? = nil,
                           style: StatusBarNotificationStyle,
                           completion: Completion? = nil) -> NotificationView {
    let window = overlayWindow ?? NotificationWindow(windowScene: windowScene, delegate: self)
    overlayWindow = window

    let view = window.statusBarViewController.present(withStyle: style) {
      completion?(self)
    }

    view.title = title
    view.subtitle = subtitle

    window.isHidden = false;
    window.statusBarViewController.setNeedsStatusBarAppearanceUpdate();

    return view
  }

  // MARK: - NotificationWindowDelegate

  func didDismissStatusBar() {
    overlayWindow?.removeFromSuperview()
    overlayWindow?.isHidden = true
    overlayWindow?.rootViewController = nil
    overlayWindow = nil
  }

  // MARK: - Public API

  // MARK: - Presentation

  /// Present a notification using the default style or a named style.
  ///
  /// - Parameters:
  ///   - title: The text to display as title
  ///   - subtitle: The text to display as subtitle
  ///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyle(named:usingStyle:prepare:)``.
  ///                If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///   - duration: The duration defines how long the notification will be visible. If not provided the notifcation will never be dismissed..
  ///   - completion: A ``Completion`` closure, which gets called once the presentation animation finishes. It won't be called after dismissal.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  public func present(_ title: String,
                      subtitle: String? = nil,
                      styleName: String? = nil,
                      duration: Double? = nil,
                      completion: Completion? = nil) -> UIView
  {
    let style = styleCache.style(forName: styleName)
    let view = present(title, subtitle: subtitle, style: style, completion: completion)
    if let duration {
      dismiss(after: duration)
    }
    return view
  }

  /// Present a notification using an included style.
  ///
  /// - Parameters:
  ///   - title: The text to display as title
  ///   - subtitle: The text to display as subtitle
  ///   - includedStyle: An existing ``IncludedStatusBarNotificationStyle``
  ///   - duration: The duration defines how long the notification will be visible. If not provided the notifcation will never be dismissed.
  ///   - completion: A ``Completion`` closure, which gets called once the presentation animation finishes. It won't be called after dismissal.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  public func present(_ title: String,
                      subtitle: String? = nil,
                      includedStyle: IncludedStatusBarNotificationStyle,
                      duration: Double? = nil,
                      completion: Completion? = nil) -> UIView
  {
    let style = styleCache.style(forIncludedStyle: includedStyle)
    let view = present(title, subtitle: subtitle, style: style, completion: completion)
    if let duration {
      dismiss(after: duration)
    }
    return view
  }

  /// Present a notification using a custom subview.
  ///
  /// The `customView` will be layouted correctly according to the selected style & the current device
  /// state (rotation, status bar visibility, etc.). The background will still be styled & layouted
  /// according to the provided style. If your custom view requires custom touch handling,
  /// make sure to set `style.canTapToHold` to `false`. Otherwise the `customView` won't
  /// receive any touches, as the internal `gestureRecognizer` would receive them.
  ///
  /// - Parameters:
  ///   - customView: A custom UIView to display as notification content.
  ///   - sizingController: An optional controller conforming to ``NotificationPresenterCustomViewSizingController``, which controls the size of a presented custom view.
  ///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyle(named:usingStyle:prepare:)``.
  ///                If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///   - completion: A ``Completion`` closure, which gets called once the presentation animation finishes.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  @objc(presentWithCustomView:sizingController:styleName:completion:)
  public func presentCustomView(_ customView: UIView,
                                sizingController: NotificationPresenterCustomViewSizingController? = nil,
                                styleName: String? = nil,
                                completion: Completion? = nil) -> UIView
  {
    let style = styleCache.style(forName: styleName)
    let view = present(nil, style: style, completion: completion)
    view.customSubview = customView
    view.customSubviewSizingController = sizingController
    return view
  }

  /// Present a notification using a custom SwiftUI view.
  ///
  /// - Parameters:
  ///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyle(named:usingStyle:prepare:)``.
  ///            If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///   - viewBuilder: A ViewBuilder closure to build your custom SwiftUI view.
  ///   - completion: A ``Completion`` closure, which gets called once the presentation animation finishes.
  @discardableResult
  public func presentSwiftView(styleName: String? = nil,
                               @ViewBuilder viewBuilder: () -> some View,
                               completion: Completion? = nil) -> UIView
  {
    let controller = UIHostingController(rootView: viewBuilder())
    controller.view.backgroundColor = .clear
    return presentCustomView(controller.view,
                             sizingController: HostingControllerSizingController(for: controller),
                             styleName: styleName,
                             completion: completion)
  }

  // MARK: - Dismissal

  /// Dismisses any currently displayed notification animated - after the provided delay, if provided.
  ///
  /// - Parameters:
  ///   - animated: If `true`, the notification will be dismissed animated according to the currently set ``StatusBarNotificationAnimationType``.
  ///   Otherwise it will be dismissed without animation.
  ///   - delay: The delay in seconds, before the notification should be dismissed.
  ///   - completion: A ``Completion`` closure, which gets called once the dismiss animation finishes.
  ///
  public func dismiss(animated: Bool = true, after delay: Double? = nil, completion: Completion? = nil) {
    overlayWindow?.statusBarViewController.dismiss(withDuration: animated ? 0.4 : 0.0, afterDelay: delay ?? 0.0, completion: {
      completion?(self)
    })
  }

  // MARK: - Style Customization

  /// Defines a new default style.
  /// The new style will be used in all future presentations that have no specific style specified.
  ///
  /// - Parameter prepare: Provides the current default ``StatusBarNotificationStyle`` instance for further customization.
  ///
  @objc
  public func updateDefaultStyle(_ prepare: PrepareStyleClosure) {
    styleCache.updateDefaultStyle(prepare)
  }

  /// Adds a new named style - based on an included style, if given.(otherwise based on the default style)
  /// This can later be used by referencing it using the `styleName`.
  ///
  /// The added style can be used in future presentations by utilizing the same `styleName` in e.g. ``present(_:subtitle:styleName:duration:completion:)``.
  /// If a style with the same name already exists, it will be replaced.
  ///
  /// - Parameters:
  ///   - name:  The styleName which will later be used to reference the added style.
  ///   - includedStyle:  The ``IncludedStatusBarNotificationStyle``, which you want to base your style on.
  ///   - prepare: Provides an ``StatusBarNotificationStyle`` instance based on the provided `includedStyle` for further customization.
  ///
  /// - Returns: Returns the `styleName`, so that this call can be used directly within a presentation call.
  ///
  @discardableResult
  @objc(addStyleNamed:basedOnStyle:prepare:)
  public func addStyle(named name: String,
                       usingStyle includedStyle: IncludedStatusBarNotificationStyle = .defaultStyle,
                       prepare: PrepareStyleClosure) -> String
  {
    return styleCache.addStyleNamed(name, basedOnStyle: includedStyle, prepare: prepare)
  }

  // MARK: - Display supplementary views

  /// Displays a progress bar at the given `percentage`.
  ///
  /// Displays the given percentage immediately without animation.
  /// The progress bar will be styled according to the current ``StatusBarNotificationProgressBarStyle``.
  ///
  /// - Parameter percentage: The percentage in a range from 0.0 to 1.0
  ///
  @objc(displayProgressBarWithPercentage:)
  public func displayProgressBar(at percentage: Double) {
    statusBarView?.progressBarPercentage = percentage
  }

  /// Displays a progress bar and animates it to the provided `percentage`.
  ///
  /// Animates the progress bar from the currently set `percentage` to the provided `percentage` using the provided `duration`.
  /// The progress bar will be styled according to the current ``StatusBarNotificationProgressBarStyle``.
  ///
  /// - Parameters:
  ///   - percentage: Relative progress from 0.0 to 1.0
  ///   - duration: The duration of the animation from the current percentage to the provided percentage.
  ///   - completion: A ``Completion``, which gets called once the progress bar animation finishes.
  ///
  @objc(animateProgressBarToPercentage:animationDuration:completion:)
  public func animateProgressBar(to percentage: Double, duration: Double, completion: Completion?) {
    statusBarView?.animateProgressBar(toPercentage: percentage, animationDuration: duration) {
      completion?(self)
    }
  }

  /// Displays an activity indicator as the notifications left view.
  ///
  /// It will have the same color as the text color of the current style by default.
  /// The color can also be set explicitly by using the `leftViewStyle.tintColor`.
  /// The layout is also defined by the ``StatusBarNotificationLeftViewStyle``.
  ///
  /// - Parameter show:  Show or hide the activity indicator.
  ///
  @objc(displayActivityIndicator:)
  public func displayActivityIndicator(_ show: Bool) {
    statusBarView?.displaysActivityIndicator = show
  }

  /// Displays a view on the left side of the text.
  /// The layout is defined by the ``StatusBarNotificationLeftViewStyle``.
  ///
  /// - Parameter leftView: A custom `UIView` to display on the left side of the text. E.g. an
  ///                       icon / image / profile picture etc. A nil value removes an existing leftView.
  ///
  @objc(displayLeftView:)
  public func displayLeftView(_ leftView: UIView?) {
    statusBarView?.leftView = leftView
  }

  // MARK: - Additional Presenter APIs

  /// Updates the title of an existing notification without animation.
  ///
  /// - Parameter title: The new title to display
  ///
  @objc(updateText:)
  public func updateTitle(_ title: String) {
    statusBarView?.title = title
  }

  /// Updates the subtitle of an existing notification without animation.
  ///
  /// - Parameter subtitle: The new subtitle to display
  ///
  @objc(updateSubtitle:)
  public func updateSubtitle(_ subtitle: String?) {
    statusBarView?.subtitle = subtitle
  }

  /// Let's you check if a notification is currently displayed.
  ///
  /// - Returns: `true` if a notification is currently displayed. Otherwise `false`.
  ///
  @objc
  public var isVisible: Bool {
    overlayWindow != nil
  }

  /// Lets you set an explicit `UIWindowScene`, in which notifications should be presented in. In most cases you don't need to set this.
  ///
  /// The `UIWindowScene` is usually inferred automatically, but if that doesn't work for your setup, you can set it explicitly.
  ///
  /// - Parameter windowScene: The `UIWindowScene` in which the notifcation should be presented.
  ///
  @objc
  public func setWindowScene(_ windowScene: UIWindowScene?) {
    self.windowScene = windowScene
  }
  private var windowScene: UIWindowScene?

  // MARK: - Private

  private var statusBarView: NotificationView? {
    return overlayWindow?.statusBarViewController.statusBarView
  }
}

// MARK: - HostingControllerSizingController

/// A protocol for a custom controller, which controls the size of a presented custom view.
@objc(JDStatusBarNotificationPresenterCustomViewSizingController)
public protocol NotificationPresenterCustomViewSizingController {
  @objc(sizeThatFits:)
  func sizeThatFits(in size: CGSize) -> CGSize
}

extension NotificationPresenter {
  private class HostingControllerSizingController<Content>: NotificationPresenterCustomViewSizingController where Content: View {
    let hostingController: UIHostingController<Content>

    init(for hostingController: UIHostingController<Content>) {
      self.hostingController = hostingController
    }

    func sizeThatFits(in size: CGSize) -> CGSize {
      return hostingController.sizeThatFits(in: size)
    }
  }
}
