//
//

class CustomStyle: ObservableObject, Equatable {
  @Published var textColor: UIColor?
  @Published var font: UIFont
  @Published var textOffsetY: CGFloat
  @Published var textShadowColor: UIColor?
  @Published var textShadowOffset: CGSize

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

  @Published var pbBarColor: UIColor?
  @Published var pbBarHeight: CGFloat { didSet {
    if pbCornerRadius > 0.0 {
      pbCornerRadius = floor(pbBarHeight / 2.0)
    }
  }}
  @Published var pbPosition: ProgressBarPosition
  @Published var pbHorizontalInsets: CGFloat
  @Published var pbCornerRadius: CGFloat
  @Published var pbBarOffset: CGFloat

  init(_ defaultStyle: StatusBarStyle) {
    textColor = UIColor(white: 0.1, alpha: 1.0)
    font = .systemFont(ofSize: 14.0)
    textOffsetY = defaultStyle.textStyle.textOffsetY
    textShadowColor = defaultStyle.textStyle.textShadowColor
    textShadowOffset = defaultStyle.textStyle.textShadowOffset

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
    systemStatusBarStyle = .defaultStyle
    canSwipeToDismiss = defaultStyle.canSwipeToDismiss

    pbBarColor = UIColor(red: 0.00392, green: 0.4313, blue: 0.5607, alpha: 1.0) // "dark cyan"
    pbBarHeight = 3.0
    pbPosition = .bottom
    pbHorizontalInsets = 20.0
    pbCornerRadius = 1.0
    pbBarOffset = -7.0
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
    style.textStyle.textColor = textColor
    style.textStyle.font = font
    style.textStyle.textOffsetY = textOffsetY
    style.textStyle.textShadowColor = textShadowColor
    style.textStyle.textShadowOffset = textShadowOffset

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
    """
    style.textStyle.textColor = \(readableRGBAColorString(textColor))
    style.textStyle.font = UIFont(name: \"\(font.familyName)\", size: \(font.pointSize))
    style.textStyle.textOffsetY = \(textOffsetY)
    """

    if let textShadowColor = textShadowColor {
      """
      style.textStyle.textShadowColor = \(readableRGBAColorString(textShadowColor))
      style.textStyle.textShadowOffset = CGSize(width: \(textShadowOffset.width), height: \(textShadowOffset.height))
      """
    }

    """
    \nstyle.backgroundStyle.backgroundColor = \(readableRGBAColorString(backgroundColor))
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
        style.backgroundStyle.pillStyle.borderColor = \(readableRGBAColorString(pillBorderColor))
        style.backgroundStyle.pillStyle.borderWidth = \(pillBorderWidth)
        """
      }

      if let pillShadowColor = pillShadowColor {
        """
        style.backgroundStyle.pillStyle.shadowColor = \(readableRGBAColorString(pillShadowColor))
        style.backgroundStyle.pillStyle.shadowRadius = \(pillShadowRadius)
        style.backgroundStyle.pillStyle.shadowOffset = CGSize(width: \(pillShadowOffset.width), height: \(pillShadowOffset.height))
        """
      }
    }

    """
    \nstyle.animationType = \(animationType.stringValue)
    style.systemStatusBarStyle = \(systemStatusBarStyle.stringValue)
    style.canSwipeToDismiss = \(canSwipeToDismiss)

    style.progressBarStyle.barHeight = \(pbBarHeight)
    style.progressBarStyle.position = \(pbPosition.stringValue)
    style.progressBarStyle.barColor = \(readableRGBAColorString(pbBarColor))
    style.progressBarStyle.horizontalInsets = \(pbHorizontalInsets)
    style.progressBarStyle.cornerRadius = \(pbCornerRadius)
    style.progressBarStyle.offsetY = \(pbBarOffset)
    """
  }

  func readableRGBAColorString(_ color: UIColor?) -> String {
    if let color = color {
      var red: CGFloat = 0
      var green: CGFloat = 0
      var blue: CGFloat = 0
      var alpha: CGFloat = 0
      color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
      if #available(iOS 14.0, *) {
        return "UIColor(red: \(red), green: \(green), blue: \(blue), alpha: \(alpha)) // \"\(color.accessibilityName)\""
      }
    }

    return "nil"
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
