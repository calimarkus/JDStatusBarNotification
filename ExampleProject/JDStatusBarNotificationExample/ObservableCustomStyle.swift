//
//

import Combine

class CustomTextStyle: ObservableObject, Equatable {
  @Published var font: UIFont
  @Published var textColor: UIColor?
  @Published var textOffsetY: Double
  @Published var shadowColor: UIColor?
  @Published var shadowOffset: CGPoint

  init(_ textStyle: NotificationTextStyle) {
    font = textStyle.font
    textColor = textStyle.textColor
    textOffsetY = textStyle.textOffsetY
    shadowColor = textStyle.shadowColor
    shadowOffset = textStyle.shadowOffset
  }

  static func == (lhs: CustomTextStyle, rhs: CustomTextStyle) -> Bool {
    return false // a hack to trigger .onChange(of: style) on every change
  }

  func computedStyle() -> NotificationTextStyle {
    let style = NotificationTextStyle()
    style.textColor = textColor
    style.font = font
    style.textOffsetY = textOffsetY
    style.shadowColor = shadowColor
    style.shadowOffset = shadowOffset
    return style
  }

  @SimpleStringBuilder
  func styleConfigurationString(propertyName: String) -> String {
    """
    style.\(propertyName).textColor = \(textColor?.initString ?? "nil")
    style.\(propertyName).font = \(font.initString)
    style.\(propertyName).textOffsetY = \(textOffsetY)
    """

    if let textShadowColor = shadowColor {
      """
      style.\(propertyName).shadowColor = \(textShadowColor.initString)
      style.\(propertyName).shadowOffset = \(shadowOffset.initString)
      """
    }
  }
}

class ObservableCustomStyle: ObservableObject, Equatable {
  @Published var textStyle: CustomTextStyle
  @Published var subtitleStyle: CustomTextStyle

  @Published var backgroundColor: UIColor?
  @Published var backgroundType: BarBackgroundType

  @Published var minimumPillWidth: Double
  @Published var pillHeight: Double
  @Published var pillSpacingY: Double
  @Published var pillBorderColor: UIColor?
  @Published var pillBorderWidth: Double
  @Published var pillShadowColor: UIColor?
  @Published var pillShadowRadius: Double
  @Published var pillShadowOffset: CGPoint

  @Published var animationType: BarAnimationType
  @Published var systemStatusBarStyle: StatusBarSystemStyle
  @Published var canSwipeToDismiss: Bool
  @Published var canTapToHold: Bool
  @Published var canDismissDuringUserInteraction: Bool

  @Published var leftViewSpacing: Double
  @Published var leftViewOffset: CGPoint
  @Published var leftViewTintColor: UIColor?
  @Published var leftViewAlignment: BarLeftViewAlignment

  @Published var pbBarColor: UIColor?
  @Published var pbBarHeight: Double
  @Published var pbPosition: ProgressBarPosition
  @Published var pbHorizontalInsets: Double
  @Published var pbCornerRadius: Double
  @Published var pbBarOffset: Double

  init(_ defaultStyle: StatusBarNotificationStyle) {
    // text
    textStyle = CustomTextStyle(defaultStyle.textStyle)
    subtitleStyle = CustomTextStyle(defaultStyle.subtitleStyle)

    // background
    backgroundColor = defaultStyle.backgroundStyle.backgroundColor
    backgroundType = defaultStyle.backgroundStyle.backgroundType
    minimumPillWidth = defaultStyle.backgroundStyle.pillStyle.minimumWidth

    // pill
    pillHeight = defaultStyle.backgroundStyle.pillStyle.height
    pillSpacingY = defaultStyle.backgroundStyle.pillStyle.topSpacing
    pillBorderColor = defaultStyle.backgroundStyle.pillStyle.borderColor
    pillBorderWidth = defaultStyle.backgroundStyle.pillStyle.borderWidth
    pillShadowColor = defaultStyle.backgroundStyle.pillStyle.shadowColor
    pillShadowRadius = defaultStyle.backgroundStyle.pillStyle.shadowRadius
    pillShadowOffset = defaultStyle.backgroundStyle.pillStyle.shadowOffsetXY

    // bar
    animationType = .bounce
    systemStatusBarStyle = .darkContent
    canSwipeToDismiss = defaultStyle.canSwipeToDismiss
    canTapToHold = defaultStyle.canTapToHold
    canDismissDuringUserInteraction = defaultStyle.canDismissDuringUserInteraction

    // left view
    leftViewSpacing = defaultStyle.leftViewStyle.spacing
    leftViewOffset = defaultStyle.leftViewStyle.offset
    leftViewTintColor = defaultStyle.leftViewStyle.tintColor
    leftViewAlignment = defaultStyle.leftViewStyle.alignment

    // progress bar
    pbBarColor = defaultStyle.progressBarStyle.barColor
    pbBarHeight = defaultStyle.progressBarStyle.barHeight
    pbPosition = defaultStyle.progressBarStyle.position
    pbHorizontalInsets = defaultStyle.progressBarStyle.horizontalInsets
    pbCornerRadius = defaultStyle.progressBarStyle.cornerRadius
    pbBarOffset = defaultStyle.progressBarStyle.offsetY
  }

  static func == (lhs: ObservableCustomStyle, rhs: ObservableCustomStyle) -> Bool {
    return false // a hack to trigger .onChange(of: style) on every change
  }

  func registerComputedStyle() -> String {
    let styleName = "custom"
    NotificationPresenter.shared().addStyle(styleName: styleName) { _ in
      computedStyle()
    }
    return styleName
  }

  func computedStyle() -> StatusBarNotificationStyle {
    let style = StatusBarNotificationStyle()

    style.textStyle = textStyle.computedStyle()
    style.subtitleStyle = subtitleStyle.computedStyle()

    style.backgroundStyle.backgroundColor = backgroundColor
    style.backgroundStyle.backgroundType = backgroundType
    style.backgroundStyle.pillStyle.minimumWidth = minimumPillWidth
    style.backgroundStyle.pillStyle.height = pillHeight
    style.backgroundStyle.pillStyle.topSpacing = pillSpacingY
    style.backgroundStyle.pillStyle.borderColor = pillBorderColor
    style.backgroundStyle.pillStyle.borderWidth = pillBorderWidth
    style.backgroundStyle.pillStyle.shadowColor = pillShadowColor
    style.backgroundStyle.pillStyle.shadowRadius = pillShadowRadius
    style.backgroundStyle.pillStyle.shadowOffsetXY = pillShadowOffset

    style.animationType = animationType
    style.systemStatusBarStyle = systemStatusBarStyle
    style.canSwipeToDismiss = canSwipeToDismiss
    style.canTapToHold = canTapToHold
    style.canDismissDuringUserInteraction = canDismissDuringUserInteraction

    style.leftViewStyle.spacing = leftViewSpacing
    style.leftViewStyle.offset = leftViewOffset
    style.leftViewStyle.tintColor = leftViewTintColor
    style.leftViewStyle.alignment = leftViewAlignment

    style.progressBarStyle.barColor = pbBarColor
    style.progressBarStyle.barHeight = pbBarHeight
    style.progressBarStyle.position = pbPosition
    style.progressBarStyle.horizontalInsets = pbHorizontalInsets
    style.progressBarStyle.cornerRadius = pbCornerRadius
    style.progressBarStyle.offsetY = pbBarOffset

    return style
  }

  @SimpleStringBuilder
  func styleConfigurationString() -> String {
    textStyle.styleConfigurationString(propertyName: "textStyle")
    ""
    subtitleStyle.styleConfigurationString(propertyName: "subtitleStyle")

    """
    \nstyle.backgroundStyle.backgroundColor = \(backgroundColor?.initString ?? "nil")
    style.backgroundStyle.backgroundType = \(backgroundType.stringValue)
    """

    if backgroundType == .pill {
      """
      \nstyle.backgroundStyle.pillStyle.minimumWidth = \(minimumPillWidth)
      style.backgroundStyle.pillStyle.height = \(pillHeight)
      style.backgroundStyle.pillStyle.topSpacing = \(pillSpacingY)
      """

      if let pillBorderColor = pillBorderColor {
        """
        style.backgroundStyle.pillStyle.borderColor = \(pillBorderColor.initString)
        style.backgroundStyle.pillStyle.borderWidth = \(pillBorderWidth)
        """
      }

      if let pillShadowColor = pillShadowColor {
        """
        style.backgroundStyle.pillStyle.shadowColor = \(pillShadowColor.initString)
        style.backgroundStyle.pillStyle.shadowRadius = \(pillShadowRadius)
        style.backgroundStyle.pillStyle.shadowOffsetXY = \(pillShadowOffset.initString)
        """
      }
    }

    """
    \nstyle.animationType = \(animationType.stringValue)
    style.systemStatusBarStyle = \(systemStatusBarStyle.stringValue)
    style.canSwipeToDismiss = \(canSwipeToDismiss)
    style.canTapToHold = \(canTapToHold)
    style.canDismissDuringUserInteraction = \(canDismissDuringUserInteraction)

    style.leftViewStyle.spacing = \(leftViewSpacing)
    style.leftViewStyle.offset = \(leftViewOffset.initString)
    style.leftViewStyle.tintColor = \(leftViewTintColor?.initString ?? "nil")
    style.leftViewStyle.alignment = \(leftViewAlignment.stringValue)

    style.progressBarStyle.barHeight = \(pbBarHeight)
    style.progressBarStyle.position = \(pbPosition.stringValue)
    style.progressBarStyle.barColor = \(pbBarColor?.initString ?? "nil")
    style.progressBarStyle.horizontalInsets = \(pbHorizontalInsets)
    style.progressBarStyle.cornerRadius = \(pbCornerRadius)
    style.progressBarStyle.offsetY = \(pbBarOffset)
    """
  }
}

@resultBuilder
enum SimpleStringBuilder {
  static func buildBlock(_ parts: String?...) -> String {
    parts.compactMap { $0 }.joined(separator: "\n")
  }

  static func buildOptional(_ component: String?) -> String? {
    return component
  }
}

extension UIColor {
  var initString: String {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    if #available(iOS 14.0, *) {
      return "UIColor(red: \(red), green: \(green), blue: \(blue), alpha: \(alpha)) // \"\(self.accessibilityName)\""
    } else {
      return "??"
    }
  }
}

extension CGPoint {
  var initString: String {
    return "CGPoint(x: \(self.x), y: \(self.y))"
  }
}

extension UIFont {
  var initString: String {
    return "UIFont(name: \"\(self.familyName)\", size: \(self.pointSize))!"
  }
}
