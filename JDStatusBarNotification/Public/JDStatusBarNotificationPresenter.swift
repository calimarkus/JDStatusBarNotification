//
//  JDStatusBarNotificationPresenter_Private.h
//
//  Created by Markus Emrich on 10/15/23.
//  Copyright 2023 Markus Emrich. All rights reserved.
//

import SwiftUI

private class NotificationPresenterSizingController<Content>: NotificationPresenterCustomViewSizingController where Content: View {
  let hostingController: UIHostingController<Content>

  init(hostingController: UIHostingController<Content>) {
    self.hostingController = hostingController
  }

  func sizeThatFits(in size: CGSize) -> CGSize {
    return hostingController.sizeThatFits(in: size)
  }
}

public extension NotificationPresenter {
  /// Present a notification.
  ///
  /// - Parameters:
  ///   - title: The text to display as title
  ///   - subtitle: The text to display as subtitle
  ///   - delay: The delay in seconds, before the notification should be dismissed.
  ///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyleNamed(_:prepare:)``.
  ///                If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///   - completion: A ``NotificationPresenterCompletion`` closure, which gets called once the presentation animation finishes. It won't be called after dismissal.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  func present(_ title: String,
               subtitle: String? = nil,
               delay: Double? = nil,
               styleName: String? = nil,
               completion: NotificationPresenterCompletion? = nil) -> UIView
  {
    let view = __present(withTitle: title, subtitle: subtitle, customStyle: styleName, completion: completion)
    if let delay {
      dismiss(delay: delay)
    }
    return view
  }

  /// Present a notification.
  ///
  /// - Parameters:
  ///   - title: The text to display as title
  ///   - subtitle: The text to display as subtitle
  ///   - delay: The delay in seconds, before the notification should be dismissed.
  ///   - includedStyle: An existing ``IncludedStatusBarNotificationStyle``
  ///   - completion: A ``NotificationPresenterCompletion`` closure, which gets called once the presentation animation finishes. It won't be called after dismissal.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  func present(_ title: String,
               subtitle: String? = nil,
               delay: Double? = nil,
               includedStyle: IncludedStatusBarNotificationStyle,
               completion: NotificationPresenterCompletion? = nil) -> UIView
  {
    let view = __present(withTitle: title, subtitle: subtitle, includedStyle: includedStyle, completion: completion)
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
  ///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyleNamed(_:prepare:)``.
  ///                If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///   - completion: A ``NotificationPresenterCompletion`` closure, which gets called once the presentation animation finishes.
  ///
  /// - Returns: The presented UIView for further customization
  ///
  @discardableResult
  func presentCustomView(_ view: UIView,
                         sizingController: NotificationPresenterCustomViewSizingController? = nil,
                         styleName: String? = nil,
                         completion: NotificationPresenterCompletion? = nil) -> UIView
  {
    return __present(withCustomView: view,
                     sizingController: sizingController,
                     styleName: styleName,
                     completion: completion)
  }

  /// Present a notification using a custom SwiftUI view.
  ///
  /// - Parameters:
  ///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyleNamed(_:prepare:)``.
  ///            If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///   - viewBuilder: A ViewBuilder closure to build your custom SwiftUI view.
  ///   - completion: A ``NotificationPresenterCompletion`` closure, which gets called once the presentation animation finishes.
  @discardableResult
  func presentSwiftView(styleName: String? = nil,
                        @ViewBuilder viewBuilder: () -> some View,
                        completion: NotificationPresenterCompletion? = nil) -> UIView
  {
    let controller = UIHostingController(rootView: viewBuilder())
    controller.view.backgroundColor = .clear
    return __present(withCustomView: controller.view,
                     sizingController: NotificationPresenterSizingController(hostingController: controller),
                     styleName: styleName,
                     completion: completion)
  }

  /// Dismisses any currently displayed notification animated - after the provided delay, if provided.
  ///
  /// - Parameters:
  ///   - delay: The delay in seconds, before the notification should be dismissed.
  ///   - completion: A ``NotificationPresenterCompletion`` closure, which gets called once the dismiss animation finishes.
  ///
  func dismiss(delay: Double? = nil,
               completion: NotificationPresenterCompletion? = nil)
  {
    if let delay {
      __dismiss(afterDelay: delay, completion: completion)
    } else {
      __dismiss(completion: completion)
    }
  }

  /// Adds a new named style - based on an included style, if given.
  /// This can later be used by referencing it using the `styleName` - or by using the return value directly.
  ///
  /// The added style can be used in future presentations by utilizing the same `styleName` in e.g. ``present(title:styleName:completion:)``.
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
  func addStyle(named name: String,
                usingStyle includedStyle: IncludedStatusBarNotificationStyle? = nil,
                prepare: NotificationPresenterPrepareStyleClosure) -> String
  {
    if let includedStyle {
      __addStyleNamed(name, basedOn: includedStyle, prepare: prepare)
    } else {
      __addStyleNamed(name, prepare: prepare)
    }
  }
}
