//
//

class CustomStyle: ObservableObject, Equatable {
  @Published var textColor: UIColor? = .white
  @Published var font: UIFont = .init(name: "Futura-Medium", size: 15.0)!
  @Published var textOffsetY: CGFloat = 0.0
  @Published var textShadowColor: UIColor? = .systemTeal
  @Published var textShadowOffset: CGSize = .init(width: 1.0, height: 2.0)

  @Published var backgroundColor: UIColor? = .systemTeal
  @Published var backgroundType: BarBackgroundType = .pill

  @Published var minimumPillWidth: Double = 160.0
  @Published var pillHeight: Double = 36.0
  @Published var pillSpacingY: Double = 6.0
  @Published var pillBorderColor: UIColor? = nil
  @Published var pillBorderWidth: Double = 0.0
  @Published var pillShadowColor: UIColor? = UIColor(white: 0.0, alpha: 0.33)
  @Published var pillShadowRadius: Double = 4.0
  @Published var pillShadowOffset: CGSize = .init(width: 0.0, height: 2.0)

  @Published var animationType: AnimationType = .bounce
  @Published var systemStatusBarStyle: StatusBarSystemStyle = .lightContent
  @Published var canSwipeToDismiss: Bool = true

  @Published var pbBarColor: UIColor? = UIColor(red: 0.774822, green: 0.817868, blue: 0.278994, alpha: 1)
  @Published var pbBarHeight: CGFloat = 6.0 { didSet {
    if pbCornerRadius > 0.0 {
      pbCornerRadius = floor(pbBarHeight / 2.0)
    }
  }}
  @Published var pbPosition: ProgressBarPosition = .bottom
  @Published var pbHorizontalInsets: CGFloat = 20.0
  @Published var pbCornerRadius: CGFloat = 3.0
  @Published var pbBarOffset: CGFloat = -3.0

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

  func styleConfigurationString() -> String {
    var text = """
    style.textStyle.textColor = \(textColor ?? .clear)
    style.textStyle.font = \(font)
    style.textStyle.textOffsetY = \(textOffsetY)
    """

    if let color = textShadowColor {
      text.append("\n")
      text.append("""
      style.textStyle.textShadowColor = \(color)
      style.textStyle.textShadowOffset = (\(textShadowOffset.width), \(textShadowOffset.height))
      """)
    }

    text.append("\n\n")
    text.append("""
    style.backgroundStyle.backgroundColor = \(backgroundColor ?? .clear)
    style.backgroundStyle.backgroundType = \(backgroundType)
    style.backgroundStyle.minimumPillWidth = \(minimumPillWidth)
    style.backgroundStyle.pillStyle.height = \(pillHeight)
    style.backgroundStyle.pillStyle.topSpacing = \(pillSpacingY)
    style.backgroundStyle.pillStyle.borderColor = \(pillBorderColor ?? .clear)
    style.backgroundStyle.pillStyle.borderWidth = \(pillBorderWidth)
    style.backgroundStyle.pillStyle.shadowColor = \(pillShadowColor ?? .clear)
    style.backgroundStyle.pillStyle.shadowRadius = \(pillShadowRadius)
    style.backgroundStyle.pillStyle.shadowOffset = (\(pillShadowOffset.width), \(pillShadowOffset.height))

    style.animationType = \(animationType)
    style.systemStatusBarStyle = \(systemStatusBarStyle)
    style.canSwipeToDismiss = \(canSwipeToDismiss)

    style.progressBarStyle.barHeight = \(pbBarHeight)
    style.progressBarStyle.position = \(pbPosition)
    style.progressBarStyle.barColor = \(pbBarColor ?? .clear)
    style.progressBarStyle.horizontalInsets = \(pbHorizontalInsets)
    style.progressBarStyle.cornerRadius = \(pbCornerRadius)
    style.progressBarStyle.offsetY = \(pbBarOffset)
    """)

    text.append("\n")

    return text
  }
}
