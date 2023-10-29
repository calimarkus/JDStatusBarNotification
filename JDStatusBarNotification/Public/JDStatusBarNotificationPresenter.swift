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
  /// Present a notification using a custom SwiftUI view.
  ///
  /// - Parameters:
  ///   - style: The name of the style. You can use styles previously added using e.g. ``addStyle(styleName:prepare:)``.
  ///            If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
  ///   - viewBuilder: A ViewBuilder closure to build your custom SwiftUI view.
  ///   - completion: A ``JDStatusBarNotificationPresenterCompletionBlock``, which gets called once the presentation animation finishes.
  func presentSwiftView(styleName: String? = nil,
                        @ViewBuilder viewBuilder: () -> some View,
                        completion: NotificationPresenterCompletion? = nil)
  {
    let controller = UIHostingController(rootView: viewBuilder())
    controller.view.backgroundColor = .clear
    __present(withCustomView: controller.view,
              sizingController: NotificationPresenterSizingController(hostingController: controller),
              styleName: styleName,
              completion: completion)
  }
}
