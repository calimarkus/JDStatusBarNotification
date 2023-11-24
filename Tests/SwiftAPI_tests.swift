//
// SwiftAPI_tests
//

import Foundation
import SwiftUI
import XCTest
import JDStatusBarNotification

class SwiftAPI_tests: XCTestCase {

  func testPresentationAPI() {
    NotificationPresenter.shared.present("x")
    NotificationPresenter.shared.present("x", subtitle: nil, styleName: nil, duration: nil, completion: nil)
    NotificationPresenter.shared.present("x", subtitle: nil, includedStyle: .defaultStyle, duration: nil, completion: nil)
    NotificationPresenter.shared.presentSwiftView(styleName: "s") {
      Text("x")
    }
    NotificationPresenter.shared.presentCustomView(UIView(), sizingController: nil, styleName: nil, completion: nil)
  }

  func testDismissalAPI() {
    NotificationPresenter.shared.dismiss()
    NotificationPresenter.shared.dismiss(animated: false)
    NotificationPresenter.shared.dismiss(after: 0)
    NotificationPresenter.shared.dismiss(completion: nil)
    NotificationPresenter.shared.dismiss(animated: false, completion: nil)
    NotificationPresenter.shared.dismiss(after: 0, completion: nil)
    NotificationPresenter.shared.dismiss(animated: true, after: nil, completion: nil)
  }

  func testStyleAPI() {
    NotificationPresenter.shared.updateDefaultStyle { style in
      return style
    }

    NotificationPresenter.shared.addStyle(named: "x", usingStyle: .defaultStyle) { style in
      return style
    }
  }

  func testOtherAPI() {
    NotificationPresenter.shared.displayProgressBar(at: 0)
    NotificationPresenter.shared.animateProgressBar(to: 0, duration: 0, completion: nil)

    NotificationPresenter.shared.displayActivityIndicator(true)
    NotificationPresenter.shared.displayLeftView(nil)

    NotificationPresenter.shared.updateTitle("x")
    NotificationPresenter.shared.updateSubtitle("x")

    _ = NotificationPresenter.shared.isVisible
  }

  @available(iOS, deprecated: 15.0)
  func testWindowSceneAPI() {
    if let scene = UIApplication.shared.windows.first?.windowScene {
      NotificationPresenter.shared.setWindowScene(scene)
    }
  }
}
