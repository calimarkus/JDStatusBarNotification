//
//  StyleCache.swift
//  JDStatusBarNotification
//
//  Created by Markus on 11/12/23.
//  Copyright © 2023 Markus. All rights reserved.
//

import Foundation
import UIKit

class StyleCache: NSObject {
  private var defaultStyle: StatusBarNotificationStyle = StatusBarNotificationStyle()
  private var userStyles: [String: StatusBarNotificationStyle] = [:]

  //  default to cached (potentially modified) default style
  func style(forName styleName: String?) -> StatusBarNotificationStyle {
    if let styleName, let style = userStyles[styleName] {
      return style
    }
    return defaultStyle
  }

  //  default to cached (potentially modified) default style
  func style(forIncludedStyle includedStyle: IncludedStatusBarNotificationStyle) -> StatusBarNotificationStyle {
    if includedStyle == .defaultStyle {
      return defaultStyle
    }
    return buildStyleForIncludedStyle(includedStyle)
  }

  func updateDefaultStyle(_ styleBuilder: NotificationPresenter.PrepareStyleClosure) {
    defaultStyle = styleBuilder(defaultStyle)
  }

  // never base this on the (potentially modified) default style
  func addStyleNamed(_ styleName: String,
                     basedOnStyle includedStyle: IncludedStatusBarNotificationStyle,
                     prepare styleBuilder: NotificationPresenter.PrepareStyleClosure) -> String
  {
    userStyles[styleName] = styleBuilder(buildStyleForIncludedStyle(includedStyle))
    return styleName
  }

  // MARK: - Included Styles

  // Always creates a new Style instance
  private func buildStyleForIncludedStyle(_ includedStyle: IncludedStatusBarNotificationStyle) -> StatusBarNotificationStyle {
      switch includedStyle {
      case .defaultStyle:
          return StatusBarNotificationStyle()

      case .light:
          let style = StatusBarNotificationStyle()
          style.backgroundStyle.backgroundColor = .white
          style.textStyle.textColor = .gray
          style.systemStatusBarStyle = .darkContent
          return style

      case .dark:
          let style = StatusBarNotificationStyle()
          style.backgroundStyle.backgroundColor = UIColor(red: 0.050, green: 0.078, blue: 0.120, alpha: 1.000)
          style.textStyle.textColor = UIColor(white: 0.95, alpha: 1.0)
          style.systemStatusBarStyle = .lightContent
          return style

      case .error:
          let style = StatusBarNotificationStyle()
          style.backgroundStyle.backgroundColor = UIColor(red: 0.588, green: 0.118, blue: 0.000, alpha: 1.000)
          style.textStyle.textColor = .white
          style.subtitleStyle.textColor = UIColor.white.withAlphaComponent(0.6)
          style.progressBarStyle.barColor = .red
          return style

      case .warning:
          let style = StatusBarNotificationStyle()
          style.backgroundStyle.backgroundColor = UIColor(red: 0.900, green: 0.734, blue: 0.034, alpha: 1.000)
          style.textStyle.textColor = .darkGray
          style.subtitleStyle.textColor = UIColor.darkGray.withAlphaComponent(0.75)
          style.progressBarStyle.barColor = style.textStyle.textColor
          return style

      case .success:
          let style = StatusBarNotificationStyle()
          style.backgroundStyle.backgroundColor = UIColor(red: 0.588, green: 0.797, blue: 0.000, alpha: 1.000)
          style.textStyle.textColor = .white
          style.subtitleStyle.textColor = UIColor(red: 0.2, green: 0.5, blue: 0.2, alpha: 1.0)
          style.progressBarStyle.barColor = UIColor(red: 0.106, green: 0.594, blue: 0.319, alpha: 1.000)
          return style

      case .matrix:
          let style = StatusBarNotificationStyle()
          style.backgroundStyle.backgroundColor = .black
          style.textStyle.textColor = .green
          style.textStyle.font = UIFont(name: "Courier-Bold", size: 14.0)!
          style.subtitleStyle.textColor = UIColor.white
          style.subtitleStyle.font = UIFont(name: "Courier", size: 12.0)!
          style.progressBarStyle.barColor = .green
          style.systemStatusBarStyle = .lightContent
          return style
      }
  }
}
