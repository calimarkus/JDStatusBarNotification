//
//  JDStatusBarNotificationPresenter_Private.h
//
//  Created by Markus Emrich on 10/15/23.
//  Copyright 2023 Markus Emrich. All rights reserved.
//

import JDStatusBarNotification
import SwiftUI

extension NotificationPresenter {

  func presentSwiftView(style: String? = nil,
                        @ViewBuilder viewBuilder: () -> some View,
                        completion: NotificationPresenterCompletion? = nil) {
    let controller = UIHostingController(rootView: viewBuilder())
    controller.view.backgroundColor = .clear
    self.present(customView: controller.view, style: style, completion: completion)
  }
}
