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
    NotificationPresenter.shared.present("x") { presenter in _ = presenter }
    NotificationPresenter.shared.present("x", subtitle: nil, styleName: nil, duration: nil, completion: nil)
    NotificationPresenter.shared.present("x", subtitle: nil, includedStyle: .defaultStyle, duration: nil, completion: nil)
    NotificationPresenter.shared.present("x", subtitle: nil, includedStyle: .defaultStyle, duration: nil) { presenter in _ = presenter }
    NotificationPresenter.shared.presentSwiftView(styleName: "s") {
      Text("x")
    }
    NotificationPresenter.shared.presentCustomView(UIView(), sizingController: nil, styleName: nil, completion: nil)
  }

  func testDismissalAPI() {
    NotificationPresenter.shared.dismiss()
    NotificationPresenter.shared.dismiss(animated: false)
    NotificationPresenter.shared.dismiss(after: 0)
    NotificationPresenter.shared.dismiss(after: 1)
    NotificationPresenter.shared.dismiss(completion: nil)
    NotificationPresenter.shared.dismiss(animated: false, completion: nil)
    NotificationPresenter.shared.dismiss(animated: true) { presenter in _ = presenter }
    NotificationPresenter.shared.dismiss(after: 0, completion: nil)
    NotificationPresenter.shared.dismiss(animated: true, after: nil, completion: nil)
  }

  func testStyleAPI() {
    NotificationPresenter.shared.updateDefaultStyle { style in return style }
    NotificationPresenter.shared.addStyle(named: "x", usingStyle: .defaultStyle) { style in return style }
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

  // MARK: - Style tests

  func testStyleEnumAvailability() {
    let _:[IncludedStatusBarNotificationStyle] = [.defaultStyle, .dark, .light, .success, .warning, .error, .matrix]
    let _:[StatusBarNotificationBackgroundType] = [.fullWidth, .pill]
    let _:[StatusBarNotificationAnimationType] = [.move, .bounce, .fade]
    let _:[StatusBarNotificationProgressBarPosition] = [.top, .center, .bottom]
    let _:[StatusBarNotificationSystemBarStyle] = [.defaultStyle, .darkContent, .lightContent]
    let _:[StatusBarNotificationLeftViewAlignment] = [.left, .centerWithText]
  }

  func testStyle() {
      let style = StatusBarNotificationStyle()

      style.textStyle = StatusBarNotificationTextStyle()
      style.subtitleStyle = StatusBarNotificationTextStyle()
      style.backgroundStyle = StatusBarNotificationBackgroundStyle()
      style.progressBarStyle = StatusBarNotificationProgressBarStyle()
      style.leftViewStyle = StatusBarNotificationLeftViewStyle()

      style.systemStatusBarStyle = .defaultStyle
      style.animationType = .move
      style.canSwipeToDismiss = false
      style.canTapToHold = false
      style.canDismissDuringUserInteraction = false
  }

  @available(*, deprecated)
  func testLeftViewStyle() {
      let style = StatusBarNotificationLeftViewStyle()

      style.spacing = 0
      style.offsetX = 0
      style.offset = .zero
      style.tintColor = nil
      style.alignment = .left
  }

  @available(*, deprecated)
  func testTextStyle() {
      let style = StatusBarNotificationTextStyle()

      style.textColor = nil
      style.font = UIFont.systemFont(ofSize: 10)
      style.textShadowColor = nil
      style.textShadowOffset = .zero
      style.shadowColor = nil
      style.shadowOffset = .zero
      style.textOffsetY = 0
  }

  @available(*, deprecated)
  func testPillStyle() {
      let style = StatusBarNotificationPillStyle()

      style.height = 0
      style.topSpacing = 0
      style.minimumWidth = 0
      style.borderColor = nil
      style.borderWidth = 0
      style.shadowColor = nil
      style.shadowRadius = 0
      style.shadowOffset = .zero
      style.shadowOffsetXY = .zero
  }

  func testBackgroundStyle() {
      let style = StatusBarNotificationBackgroundStyle()

      style.backgroundColor = nil
      style.backgroundType = .pill
      style.pillStyle = StatusBarNotificationPillStyle()
  }

  func testProgressBarStyle() {
      let style = StatusBarNotificationProgressBarStyle()

      style.barColor = nil
      style.barHeight = 0
      style.position = .bottom
      style.horizontalInsets = 0
      style.offsetY = 0
      style.cornerRadius = 0
  }

}
