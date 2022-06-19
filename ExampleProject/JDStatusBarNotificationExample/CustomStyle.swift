//
//

import Combine

class CustomTextStyle: ObservableObject, Equatable {
  @Published var font: UIFont
  @Published var textColor: UIColor?
  @Published var textOffsetY: Double
  @Published var textShadowColor: UIColor?
  @Published var textShadowOffset: CGSize

  init(_ textStyle: NotificationTextStyle) {
    font = textStyle.font
    textColor = textStyle.textColor
    textOffsetY = textStyle.textOffsetY
    textShadowColor = textStyle.textShadowColor
    textShadowOffset = textStyle.textShadowOffset
  }

  static func == (lhs: CustomTextStyle, rhs: CustomTextStyle) -> Bool {
    return false // a hack to trigger .onChange(of: style) on every change
  }

  func computedStyle() -> NotificationTextStyle {
    let style = NotificationTextStyle()
    style.textColor = textColor
    style.font = font
    style.textOffsetY = textOffsetY
    style.textShadowColor = textShadowColor
    style.textShadowOffset = textShadowOffset
    return style
  }

  @SimpleStringBuilder
  func styleConfigurationString(propertyName: String) -> String {
    """
    style.\(propertyName).textColor = \(textColor?.readableRGBAColorString ?? "nil")
    style.\(propertyName).font = UIFont(name: \"\(font.familyName)\", size: \(font.pointSize))!
    style.\(propertyName).textOffsetY = \(textOffsetY)
    """

    if let textShadowColor = textShadowColor {
      """
      style.\(propertyName).textShadowColor = \(textShadowColor.readableRGBAColorString)
      style.\(propertyName).textShadowOffset = CGSize(width: \(textShadowOffset.width), height: \(textShadowOffset.height))
      """
    }
  }
}

class CustomStyle: ObservableObject, Equatable {
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
  @Published var pillShadowOffset: CGSize

  @Published var animationType: BarAnimationType
  @Published var systemStatusBarStyle: StatusBarSystemStyle
  @Published var canSwipeToDismiss: Bool

  @Published var leftViewSpacing: Double
  @Published var leftViewOffsetX: Double
  @Published var leftViewAlignment: BarLeftViewAlignment

  @Published var pbBarColor: UIColor?
  @Published var pbBarHeight: Double
  @Published var pbPosition: ProgressBarPosition
  @Published var pbHorizontalInsets: Double
  @Published var pbCornerRadius: Double
  @Published var pbBarOffset: Double

  init(_ defaultStyle: StatusBarStyle) {
    let text = CustomTextStyle(defaultStyle.textStyle)
    text.textColor = UIColor(white: 0.1, alpha: 1.0)
    text.font = .systemFont(ofSize: 14.0)
    text.textOffsetY = -4.0
    textStyle = text

    let subtitle = CustomTextStyle(defaultStyle.subtitleStyle)
    subtitle.textColor = UIColor(white: 0.1, alpha: 0.66)
    subtitleStyle = subtitle

    backgroundColor = UIColor(red: 0.7960, green: 0.9411, blue: 0.9999, alpha: 1.0) // "light cyan blue"
    backgroundType = defaultStyle.backgroundStyle.backgroundType
    minimumPillWidth = 200.0
    pillHeight = 50.0
    pillSpacingY = 2.0
    pillBorderColor = defaultStyle.backgroundStyle.pillStyle.borderColor
    pillBorderWidth = defaultStyle.backgroundStyle.pillStyle.borderWidth
    pillShadowColor = UIColor(white: 0.0, alpha: 0.08)
    pillShadowRadius = defaultStyle.backgroundStyle.pillStyle.shadowRadius
    pillShadowOffset = defaultStyle.backgroundStyle.pillStyle.shadowOffset

    animationType = .bounce
    systemStatusBarStyle = .darkContent
    canSwipeToDismiss = defaultStyle.canSwipeToDismiss

    leftViewSpacing = defaultStyle.leftViewStyle.spacing
    leftViewOffsetX = defaultStyle.leftViewStyle.offsetX
    leftViewAlignment = defaultStyle.leftViewStyle.alignment

    pbBarColor = UIColor(red: 0.3, green: 0.31, blue: 0.52, alpha: 1.0) // "dark cyan blue"
    pbBarHeight = 4.0
    pbPosition = .bottom
    pbHorizontalInsets = 20.0
    pbCornerRadius = 2.0
    pbBarOffset = -4.0
  }

  static func == (lhs: CustomStyle, rhs: CustomStyle) -> Bool {
    return false // a hack to trigger .onChange(of: style) on every change
  }

  func registerComputedStyle() -> String {
    let styleName = "custom"
    NotificationPresenter.shared().addStyle(styleName: styleName) { _ in
      computedStyle()
    }
    return styleName
  }

  func computedStyle() -> StatusBarStyle {
    let style = StatusBarStyle()

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
    style.backgroundStyle.pillStyle.shadowOffset = pillShadowOffset

    style.animationType = animationType
    style.systemStatusBarStyle = systemStatusBarStyle
    style.canSwipeToDismiss = canSwipeToDismiss

    style.leftViewStyle.spacing = leftViewSpacing
    style.leftViewStyle.offsetX = leftViewOffsetX
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
    \nstyle.backgroundStyle.backgroundColor = \(backgroundColor?.readableRGBAColorString ?? "nil")
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
        style.backgroundStyle.pillStyle.borderColor = \(pillBorderColor.readableRGBAColorString)
        style.backgroundStyle.pillStyle.borderWidth = \(pillBorderWidth)
        """
      }

      if let pillShadowColor = pillShadowColor {
        """
        style.backgroundStyle.pillStyle.shadowColor = \(pillShadowColor.readableRGBAColorString)
        style.backgroundStyle.pillStyle.shadowRadius = \(pillShadowRadius)
        style.backgroundStyle.pillStyle.shadowOffset = CGSize(width: \(pillShadowOffset.width), height: \(pillShadowOffset.height))
        """
      }
    }

    """
    \nstyle.animationType = \(animationType.stringValue)
    style.systemStatusBarStyle = \(systemStatusBarStyle.stringValue)
    style.canSwipeToDismiss = \(canSwipeToDismiss)

    style.leftViewStyle.spacing = \(leftViewSpacing)
    style.leftViewStyle.offsetX = \(leftViewOffsetX)
    style.leftViewStyle.alignment = \(leftViewAlignment.stringValue)

    style.progressBarStyle.barHeight = \(pbBarHeight)
    style.progressBarStyle.position = \(pbPosition.stringValue)
    style.progressBarStyle.barColor = \(pbBarColor?.readableRGBAColorString ?? "nil")
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
  var readableRGBAColorString: String {
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
