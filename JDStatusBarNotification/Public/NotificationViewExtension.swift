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

  nonisolated public func notification(isPresented: Binding<Bool>, includedStyle: IncludedStatusBarNotificationStyle? = nil, @ViewBuilder viewBuilder: () -> some View) -> some View {
    let np = NotificationPresenter.shared
    var styleName: String? = nil
    if let includedStyle {
      styleName = np.addStyle(named: SwiftUINotficationState.internalStyleName, usingStyle: includedStyle) { return $0 }
    }
    return notification(isPresented: isPresented, styleName: styleName, viewBuilder: viewBuilder)
  }

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
