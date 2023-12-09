//
//

import JDStatusBarNotification
import UIKit

struct NotificationContent {
  var title: String
  var subtitle: String? = nil
}

enum ExampleStyle: String, RawRepresentable, CaseIterable {
  case loveIt
  case levelUp
  case looksGood
  case smallPill
  case iconLeftView
  case editor

  var exampleContent: NotificationContent {
    switch self {
      case .loveIt:
        return NotificationContent(title: "Love it!")
      case .levelUp:
        return NotificationContent(title: "Level Up!")
      case .looksGood:
        return NotificationContent(title: "Presenting", subtitle: "This is looking good")
      case .smallPill:
        return NotificationContent(title: "Oh, hello there!")
      case .iconLeftView:
        return NotificationContent(title: "Icon Left View")
      case .editor:
        return NotificationContent(title: "Edit me", subtitle: "in the Style Editor")
    }
  }

  func register(for backgroundType: StatusBarNotificationBackgroundType) {
    let style = buildStyle()
    style.backgroundStyle.backgroundType = backgroundType
    NotificationPresenter.shared.addStyle(named: rawValue) { _ in
      style
    }
  }

  func buildStyle() -> StatusBarNotificationStyle {
    switch self {
      case .loveIt:
        let style = StatusBarNotificationStyle()
        style.backgroundStyle.backgroundColor = UIColor(red: 0.797, green: 0.0, blue: 0.662, alpha: 1.0)
        style.textStyle.textColor = .white
        style.animationType = .fade
        style.textStyle.font = UIFont(name: "SnellRoundhand-Bold", size: 20.0)!
        style.progressBarStyle.barColor = UIColor(red: 0.986, green: 0.062, blue: 0.598, alpha: 1.0)
        style.progressBarStyle.barHeight = 400.0
        style.progressBarStyle.cornerRadius = 0.0
        style.progressBarStyle.horizontalInsets = 0.0
        style.progressBarStyle.offsetY = 0.0
        return style

      case .levelUp:
        let style = StatusBarNotificationStyle()
        style.backgroundStyle.backgroundColor = .cyan
        style.textStyle.textColor = UIColor(red: 0.056, green: 0.478, blue: 0.998, alpha: 1.0)
        style.textStyle.textOffsetY = 3.0
        style.animationType = .bounce
        style.textStyle.font = UIFont(name: "DINCondensed-Bold", size: 17.0)!
        style.progressBarStyle.barColor = UIColor(white: 1.0, alpha: 0.66)
        style.progressBarStyle.barHeight = 6.0
        style.progressBarStyle.cornerRadius = 3.0
        style.progressBarStyle.horizontalInsets = 20.0
        style.progressBarStyle.position = .center
        style.progressBarStyle.offsetY = -2.0
        return style

      case .looksGood:
        let style = StatusBarNotificationStyle()
        style.backgroundStyle.backgroundColor = UIColor(red: 0.9999999403953552, green: 0.3843138813972473, blue: 0.31372547149658203, alpha: 1.0) // "red"
        style.textStyle.textColor = .black
        style.textStyle.font = UIFont(name: "Noteworthy-Bold", size: 13.0)!
        style.textStyle.textOffsetY = 2.0
        style.subtitleStyle.textColor = UIColor(red: 0.48235297203063965, green: 0.16078439354896545, blue: -6.016343867543128e-09, alpha: 1.0) // "dark red orange"
        style.subtitleStyle.font = UIFont(name: "Noteworthy", size: 14.0)!
        style.subtitleStyle.textOffsetY = -6.0
        style.systemStatusBarStyle = .darkContent
        style.progressBarStyle.position = .bottom
        style.progressBarStyle.barColor = .white
        style.progressBarStyle.barHeight = 4.0
        style.progressBarStyle.cornerRadius = 2.0
        style.progressBarStyle.horizontalInsets = 40.0
        style.progressBarStyle.offsetY = -2.0
        return style

      case .smallPill:
        let style = StatusBarNotificationStyle()
        style.textStyle.textColor = UIColor(red: 0.003921307157725096, green: 0.11372547596693039, blue: 0.34117642045021057, alpha: 1.0) // "dark blue"
        style.textStyle.font = UIFont(name: ".AppleSystemUIFont", size: 14.0)!
        style.textStyle.textOffsetY = -3.0

        style.subtitleStyle.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.66) // "dark gray"
        style.subtitleStyle.font = UIFont(name: ".AppleSystemUIFont", size: 11.0)!

        style.backgroundStyle.backgroundColor = UIColor(red: 0.960784375667572, green: 0.9254902005195618, blue: -9.626150188069005e-08, alpha: 1.0) // "light vibrant yellow"

        style.backgroundStyle.pillStyle.minimumWidth = 0.0
        style.backgroundStyle.pillStyle.height = 32.0
        style.backgroundStyle.pillStyle.topSpacing = 2.0
        style.backgroundStyle.pillStyle.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.33) // "black"
        style.backgroundStyle.pillStyle.shadowRadius = 4.0
        style.backgroundStyle.pillStyle.shadowOffsetXY = CGPoint(x: 0.0, y: 2.0)

        style.progressBarStyle.barHeight = 4.0
        style.progressBarStyle.position = .bottom
        style.progressBarStyle.barColor = UIColor(red: 0.3, green: 0.31, blue: 0.52, alpha: 1.0) // "dark blue"
        style.progressBarStyle.horizontalInsets = 20.0
        style.progressBarStyle.cornerRadius = 2.0
        style.progressBarStyle.offsetY = -3.0
        return style

      case .iconLeftView:
        let style = StatusBarNotificationStyle()
        style.backgroundStyle.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        style.backgroundStyle.pillStyle.minimumWidth = 200.0
        style.backgroundStyle.pillStyle.height = 50.0
        style.systemStatusBarStyle = .lightContent
        style.leftViewStyle.alignment = .left
        style.leftViewStyle.spacing = 10.0
        style.leftViewStyle.offset.x = -8.0
        style.leftViewStyle.tintColor = UIColor.orange
        style.textStyle.textColor = UIColor.white
        style.textStyle.font = UIFont.boldSystemFont(ofSize: 13.0)
        style.textStyle.textOffsetY = 1

        style.subtitleStyle.textColor = UIColor.lightGray
        style.subtitleStyle.font = UIFont.systemFont(ofSize: 12.0)
        return style

      case .editor:
        let style = StatusBarNotificationStyle()

        style.textStyle.textColor = UIColor(white: 0.1, alpha: 1.0)
        style.textStyle.font = .systemFont(ofSize: 14.0)
        style.textStyle.textOffsetY = -4.0
        style.subtitleStyle.textColor = UIColor(white: 0.1, alpha: 0.66)

        style.backgroundStyle.backgroundType = .pill
        style.backgroundStyle.backgroundColor = UIColor(red: 0.7960, green: 0.9411, blue: 0.9999, alpha: 1.0) // "light cyan blue"
        style.backgroundStyle.pillStyle.shadowColor = UIColor(white: 0.0, alpha: 0.08)
        style.backgroundStyle.pillStyle.topSpacing = 2.0
        style.animationType = .bounce
        style.systemStatusBarStyle = .darkContent

        style.progressBarStyle.barColor = UIColor(red: 0.3, green: 0.31, blue: 0.52, alpha: 1.0) // "dark cyan blue"
        style.progressBarStyle.barHeight = 4.0
        style.progressBarStyle.position = .bottom
        style.progressBarStyle.horizontalInsets = 20.0
        style.progressBarStyle.cornerRadius = 2.0
        style.progressBarStyle.offsetY = -4.0

        return style
    }
  }
}
