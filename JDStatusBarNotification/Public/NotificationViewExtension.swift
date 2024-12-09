//
//  NotificationViewExtension.swift
//  JDStatusBarNotification
//
//  Created by Markus on 12/7/24.
//  Copyright © 2024 Markus. All rights reserved.
//

import SwiftUI

private struct SwiftUINotficationState {
  static var notificationId: UUID? = nil
  static let internalStyleName = "__swiftui-extension-style"
}

extension View {
  public typealias NotificationPrepareStyleClosure = (StatusBarNotificationStyle) -> Void

  /// Presents a notification when a given condition is true.
  ///
  /// - Parameters:
  ///   - isPresented: A binding to a Boolean value that determines whether to
  ///     present the notification. When the notification gets dismissed for any reason,
  ///     this value will be set to `false` again.
  ///   - style:  A ``NotificationPrepareStyleClosure`` to customize a ``StatusBarNotificationStyle`` freely.
  ///   - viewBuilder: A ViewBuilder closure to build your custom SwiftUI view.
  ///
  /// The `View` created by the `viewBuilder` will be layouted according to the selected style & the current device
  /// state (rotation, status bar visibility, etc.). The background will be styled & layouted
  /// according to the provided style. If your custom view requires custom touch handling,
  /// make sure to set `style.canTapToHold` to `false`. Otherwise the `customView` won't receive any touches.
  ///
  nonisolated public func notification(isPresented: Binding<Bool>, style: NotificationPrepareStyleClosure? = nil, @ViewBuilder viewBuilder: () -> some View) -> some View {
    let np = NotificationPresenter.shared
    var styleName: String? = nil
    if let style {
      styleName = np.addStyle(named: SwiftUINotficationState.internalStyleName) { s in
        let _ = style(s)
        return s
      }
    }
    return notification(isPresented: isPresented, styleName: styleName, viewBuilder: viewBuilder)
  }


  /// Presents a notification when a given condition is true.
  ///
  /// - Parameters:
  ///   - isPresented: A binding to a Boolean value that determines whether to
  ///     present the notification. When the notification gets dismissed for any reason,
  ///     this value will be set to `false` again.
  ///   - includedStyle:  A predefined ``IncludedStatusBarNotificationStyle`` to style this notification.
  ///   - viewBuilder: A ViewBuilder closure to build your custom SwiftUI view.
  ///
  /// The `View` created by the `viewBuilder` will be layouted according to the selected style & the current device
  /// state (rotation, status bar visibility, etc.). The background will be styled & layouted
  /// according to the provided style. If your custom view requires custom touch handling,
  /// make sure to set `style.canTapToHold` to `false`. Otherwise the `customView` won't receive any touches.
  ///
  nonisolated public func notification(isPresented: Binding<Bool>, includedStyle: IncludedStatusBarNotificationStyle? = nil, @ViewBuilder viewBuilder: () -> some View) -> some View {
    let np = NotificationPresenter.shared
    var styleName: String? = nil
    if let includedStyle {
      styleName = np.addStyle(named: SwiftUINotficationState.internalStyleName, usingStyle: includedStyle) { return $0 }
    }
    return notification(isPresented: isPresented, styleName: styleName, viewBuilder: viewBuilder)
  }


  /// Presents a notification when a given condition is true.
  ///
  /// - Parameters:
  ///   - isPresented: A binding to a Boolean value that determines whether to
  ///     present the notification. When the notification gets dismissed for any reason,
  ///     this value will be set to `false` again.
  ///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyle(named:usingStyle:prepare:)``.
  ///            If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///   - viewBuilder: A ViewBuilder closure to build your custom SwiftUI view.
  ///
  /// The `View` created by the `viewBuilder` will be layouted according to the selected style & the current device
  /// state (rotation, status bar visibility, etc.). The background will be styled & layouted
  /// according to the provided style. If your custom view requires custom touch handling,
  /// make sure to set `style.canTapToHold` to `false`. Otherwise the `customView` won't receive any touches.
  ///
  nonisolated public func notification(isPresented: Binding<Bool>, styleName: String? = nil, @ViewBuilder viewBuilder: () -> some View) -> some View {
    let np = NotificationPresenter.shared

    // dismiss if needed
    if !isPresented.wrappedValue && np.isVisible && np.activeNotificationId == SwiftUINotficationState.notificationId {
      np.dismiss(animated: true)
    }

    // present if needed
    if isPresented.wrappedValue && SwiftUINotficationState.notificationId == nil {
      np.presentSwiftView(styleName: styleName, viewBuilder: viewBuilder)

      // remember id of our presentation
      SwiftUINotficationState.notificationId = np.activeNotificationId

      // setup callback to react to other calls replacing this presentation
      np.didPresentNotificationClosure = {
        if $0.activeNotificationId != SwiftUINotficationState.notificationId {
          isPresented.wrappedValue = false
          SwiftUINotficationState.notificationId = nil
        }
      }

      // reset state on dismissal
      np.didDismissNotificationClosure = {
        $0.didPresentNotificationClosure = nil
        $0.didDismissNotificationClosure = nil
        SwiftUINotficationState.notificationId = nil
        isPresented.wrappedValue = false
      }
    }

    return self
  }
}
