//
//  JDStatusBarNotificationPresenter_Private.h
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
public class NotificationPresenter {

  /// Provides access to the shared presenter. This is the entry point to present, style and dismiss notifications.
  ///
  /// - Returns: An initialized ``NotificationPresenter`` instance.
  public static let shared = NotificationPresenter()

  /// Called upon animation completion.
  ///
  /// - Parameter presenter: Provides the shared ``NotificationPresenter`` instance. That simplifies any subsequent calls to it upon completion.
  ///
  public typealias Completion = (_ presenter: NotificationPresenter) -> ()

  /// Creates a modified copy of an existing ``StatusBarNotificationStyle`` instance.
  ///
  /// - Parameter style: The current default ``StatusBarNotificationStyle`` instance.
  ///
  /// - Returns: The modified ``StatusBarNotificationStyle`` instance.
  ///
  public typealias PrepareStyleClosure = (StatusBarNotificationStyle) -> StatusBarNotificationStyle

  let presenter: __JDStatusBarNotificationPresenter
  init() {
    presenter = __JDStatusBarNotificationPresenter.shared()
  }

  // MARK: - Presentation

  /// Present a notification using the default style or a named style.
  ///
  /// - Parameters:
  ///   - title: The text to display as title
  ///   - subtitle: The text to display as subtitle
  ///   - delay: The delay in seconds, before the notification should be dismissed.
  ///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyle(named:usingStyle:prepare:)``.
  ///                If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///   - completion: A ``Completion`` closure, which gets called once the presentation animation finishes. It won't be called after dismissal.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  public func present(_ title: String,
                      subtitle: String? = nil,
                      delay: Double? = nil,
                      styleName: String? = nil,
                      completion: Completion? = nil) -> UIView
  {
    let view = presenter.present(withTitle: title, subtitle: subtitle, customStyle: styleName, completion: { _ in completion?(self) })
    if let delay {
      dismiss(delay: delay)
    }
    return view
  }

  /// Present a notification using an included style.
  ///
  /// - Parameters:
  ///   - title: The text to display as title
  ///   - subtitle: The text to display as subtitle
  ///   - delay: The delay in seconds, before the notification should be dismissed.
  ///   - includedStyle: An existing ``IncludedStatusBarNotificationStyle``
  ///   - completion: A ``Completion`` closure, which gets called once the presentation animation finishes. It won't be called after dismissal.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  public func present(_ title: String,
                      subtitle: String? = nil,
                      delay: Double? = nil,
                      includedStyle: IncludedStatusBarNotificationStyle,
                      completion: Completion? = nil) -> UIView
  {
    let view = presenter.present(withTitle: title, subtitle: subtitle, includedStyle: includedStyle, completion: { _ in completion?(self) })
    if let delay {
      dismiss(delay: delay)
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
  ///   - view: A custom UIView to display as notification content.
  ///   - sizingController: An optional controller conforming to ``NotificationPresenterCustomViewSizingController``, which controls the size of a presented custom view.
  ///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyle(named:usingStyle:prepare:)``.
  ///                If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///   - completion: A ``Completion`` closure, which gets called once the presentation animation finishes.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  public func presentCustomView(_ view: UIView,
                                sizingController: NotificationPresenterCustomViewSizingController? = nil,
                                styleName: String? = nil,
                                completion: Completion? = nil) -> UIView
  {
    return presenter.present(withCustomView: view,
                             sizingController: sizingController,
                             styleName: styleName,
                             completion: { _ in completion?(self) })
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
    return presenter.present(withCustomView: controller.view,
                             sizingController: HostingControllerSizingController(for: controller),
                             styleName: styleName,
                             completion: { _ in completion?(self) })
  }

  // MARK: - Dismissal

  /// Dismisses any currently displayed notification.
  ///
  /// - Parameter animated: If `true`, the notification will be dismissed animated according to the currently
  ///                       set ``StatusBarNotificationAnimationType``. Otherwise it will be dismissed without animation.
  ///
  public func dismissAnimated(_ animated: Bool) {
    presenter.dismiss(animated: animated)
  }

  /// Dismisses any currently displayed notification animated - after the provided delay, if provided.
  ///
  /// - Parameters:
  ///   - delay: The delay in seconds, before the notification should be dismissed.
  ///   - completion: A ``Completion`` closure, which gets called once the dismiss animation finishes.
  ///
  public func dismiss(delay: Double? = nil, completion: Completion? = nil)
  {
    if let delay {
      presenter.dismiss(afterDelay: delay, completion: { _ in completion?(self) })
    } else {
      presenter.dismiss(completion: { _ in completion?(self) })
    }
  }

  /// Defines a new default style.
  /// The new style will be used in all future presentations that have no specific style specified.
  ///
  /// - Parameter prepare: Provides the current default ``StatusBarNotificationStyle`` instance for further customization.
  ///
  public func updateDefaultStyle(_ prepare: PrepareStyleClosure) {
    presenter.updateDefaultStyle(prepare)
  }

  // MARK: - Style Customization

  /// Adds a new named style - based on an included style, if given.
  /// This can later be used by referencing it using the `styleName` - or by using the return value directly.
  ///
  /// The added style can be used in future presentations by utilizing the same `styleName` in e.g. ``present(_:subtitle:delay:styleName:completion:)``.
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
  public func addStyle(named name: String,
                       usingStyle includedStyle: IncludedStatusBarNotificationStyle? = nil,
                       prepare: PrepareStyleClosure) -> String
  {
    if let includedStyle {
      presenter.addStyleNamed(name, basedOn: includedStyle, prepare: prepare)
    } else {
      presenter.addStyleNamed(name, prepare: prepare)
    }
  }

  // MARK: - Display supplementary views

  /// Displays a progress bar at the given `percentage`.
  ///
  /// Displays the given percentage immediately without animation.
  /// The progress bar will be styled according to the current ``StatusBarNotificationProgressBarStyle``.
  ///
  /// - Parameter percentage: The percentage in a range from 0.0 to 1.0
  ///
  public func displayProgressBar(at percentage: Double) {
    presenter.displayProgressBar(withPercentage: percentage)
  }

  /// Displays a progress bar and animates it to the provided `percentage`.
  ///
  /// Animates the progress bar from the currently set `percentage` to the provided `percentage` using the provided `duration`.
  /// The progress bar will be styled according to the current ``StatusBarNotificationProgressBarStyle``.
  ///
  /// - Parameters:
  ///   - percentage: Relative progress from 0.0 to 1.0
  ///   - animationDuration: The duration of the animation from the current percentage to the provided percentage.
  ///   - completion: A ``Completion``, which gets called once the progress bar animation finishes.
  ///
  public func animateProgressBar(to percentage: Double, duration: Double, completion: Completion?) {
    presenter.animateProgressBar(toPercentage: percentage, animationDuration: duration, completion: { _ in completion?(self) })
  }

  /// Displays an activity indicator as the notifications left view.
  ///
  /// It will have the same color as the text color of the current style by default.
  /// The color can also be set explicitly by using the `leftViewStyle.tintColor`.
  /// The layout is also defined by the ``StatusBarNotificationLeftViewStyle``.
  ///
  /// - Parameter show:  Show or hide the activity indicator.
  ///
  public func displayActivityIndicator(_ show: Bool) {
    presenter.displayActivityIndicator(show)
  }

  /// Displays a view on the left side of the text.
  /// The layout is defined by the ``StatusBarNotificationLeftViewStyle``.
  ///
  /// - Parameter leftView: A custom `UIView` to display on the left side of the text. E.g. an
  ///                       icon / image / profile picture etc. A nil value removes an existing leftView.
  ///
  public func displayLeftView(_ leftView: UIView?) {
    presenter.displayLeftView(leftView)
  }

  // MARK: - Additional Presenter APIs

  /// Updates the title of an existing notification without animation.
  ///
  /// - Parameter title: The new title to display
  ///
  public func updateTitle(_ title: String) {
    presenter.updateText(title)
  }

  /// Updates the subtitle of an existing notification without animation.
  ///
  /// - Parameter subtitle: The new subtitle to display
  ///
  public func updateSubtitle(_ subtitle: String?) {
    presenter.updateSubtitle(subtitle)
  }

  /// Let's you check if a notification is currently displayed.
  ///
  /// - Returns: `true` if a notification is currently displayed. Otherwise `false`.
  ///
  public var isVisible: Bool {
    return presenter.isVisible()
  }

  /// Lets you set an explicit `UIWindowScene`, in which notifications should be presented in. In most cases you don't need to set this.
  ///
  /// The `UIWindowScene` is usually inferred automatically, but if that doesn't work for your setup, you can set it explicitly.
  ///
  /// - Parameter windowScene: The `UIWindowScene` in which the notifcation should be presented.
  ///
  public func setWindowScene(_ windowScene: UIWindowScene) {
    presenter.setWindowScene(windowScene)
  }

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
