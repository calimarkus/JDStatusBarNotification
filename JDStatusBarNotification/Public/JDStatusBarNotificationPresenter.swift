//
//  JDStatusBarNotificationPresenter_Private.h
//
//  Created by Markus Emrich on 10/15/23.
//  Copyright 2023 Markus Emrich. All rights reserved.
//

import SwiftUI

class NotificationPresenterSizingController<Content>: NotificationPresenterCustomViewSizingController where Content: View {
  let hostingController: UIHostingController<Content>

  init(hostingController: UIHostingController<Content>) {
    self.hostingController = hostingController
  }

  func sizeThatFits(in size: CGSize) -> CGSize {
    return hostingController.sizeThatFits(in: size)
  }
}

public extension NotificationPresenter {
  func presentSwiftView(style: String? = nil,
                        @ViewBuilder viewBuilder: () -> some View,
                        completion: NotificationPresenterCompletion? = nil)
  {
    let controller = UIHostingController(rootView: viewBuilder())
    controller.view.backgroundColor = .clear
    present(customView: controller.view,
            sizingController: NotificationPresenterSizingController(hostingController: controller),
            style: style,
            completion: completion)
  }
}
