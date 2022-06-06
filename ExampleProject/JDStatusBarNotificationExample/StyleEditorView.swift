//
//

import SwiftUI

@available(iOS 15.0, *)
class StyleEditorViewFactory: NSObject {
  static let initialText = "You are doing great!"
  static let initialProgress = 0.55

  @objc static func createStyleEditorView() -> UIViewController {
    presentInitialNotification()
    return UIHostingController(rootView: StyleEditorView(text: initialText, showActivity: true, progress: initialProgress))
  }

  static func presentInitialNotification() {
    StyleEditorView.statusBarView = NotificationPresenter.shared().present(text: initialText, customStyle: CustomStyle().registerComputedStyle())
    NotificationPresenter.shared().displayActivityIndicator(true)
    NotificationPresenter.shared().displayProgressBar(percentage: initialProgress)
  }
}

class CustomStyle: ObservableObject, Equatable {
  @Published var textColor: UIColor? = .white
  @Published var font: UIFont = .init(name: "Futura-Medium", size: 15.0)!
  @Published var textOffsetY: CGFloat = 0.0
  @Published var textShadowColor: UIColor? = .systemTeal
  @Published var textShadowOffset: CGSize = .init(width: 2.0, height: 2.0)

  @Published var backgroundColor: UIColor? = .systemTeal
  @Published var backgroundType: BarBackgroundType = .pill
  @Published var minimumPillWidth: Double = 160.0
  @Published var pillHeight: Double = 36.0
  @Published var pillSpacingY: Double = 6.0

  @Published var animationType: AnimationType = .bounce
  @Published var systemStatusBarStyle: StatusBarSystemStyle = .lightContent
  @Published var canSwipeToDismiss: Bool = true

  @Published var pbBarColor: UIColor? = .orange
  @Published var pbBarHeight: CGFloat = 26.0 { didSet {
    if pbCornerRadius > 0.0 {
      pbCornerRadius = floor(pbBarHeight / 2.0)
    }
  }}
  @Published var pbPosition: ProgressBarPosition = .center
  @Published var pbHorizontalInsets: CGFloat = 6.0
  @Published var pbCornerRadius: CGFloat = 13.0
  @Published var pbBarOffset: CGFloat = -1.0

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
    style.textStyle.textColor = \(textColor ?? .white)
    style.textStyle.font = \(font)
    style.textStyle.textOffsetY = \(textOffsetY)
    """

    if let color = textShadowColor {
      text.append("\n")
      text.append("""
      style.textStyle.textShadowColor = \(color)
      style.textStyle.textShadowOffset = \(textShadowOffset)
      """)
    }

    text.append("\n\n")
    text.append("""
    style.backgroundStyle.backgroundColor = \(backgroundColor ?? .white)
    style.backgroundStyle.backgroundType = \(backgroundType)
    style.backgroundStyle.minimumPillWidth = \(minimumPillWidth)
    style.backgroundStyle.pillStyle.height = \(pillHeight)
    style.backgroundStyle.pillStyle.topSpacing = \(pillSpacingY)

    style.animationType = \(animationType)
    style.systemStatusBarStyle = \(systemStatusBarStyle)
    style.canSwipeToDismiss = \(canSwipeToDismiss)

    style.progressBarStyle.barHeight = \(pbBarHeight)
    style.progressBarStyle.position = \(pbPosition)
    style.progressBarStyle.barColor = \(pbBarColor ?? .white)
    style.progressBarStyle.horizontalInsets = \(pbHorizontalInsets)
    style.progressBarStyle.cornerRadius = \(pbCornerRadius)
    style.progressBarStyle.offsetY = \(pbBarOffset)
    """)

    text.append("\n")

    return text
  }
}

@available(iOS 15.0, *)
struct StyleEditorView: View {
  @State var text: String
  @State var showActivity: Bool
  @State var progress: Double
  @StateObject var style: CustomStyle = .init()

  weak static var statusBarView: JDStatusBarView? = nil

  func presentDefault() {
    StyleEditorView.statusBarView = NotificationPresenter.shared().present(
      text: text,
      customStyle: style.registerComputedStyle()
    )
    if showActivity {
      NotificationPresenter.shared().displayActivityIndicator(true)
    }
    if progress > 0.0 {
      NotificationPresenter.shared().displayProgressBar(percentage: progress)
    }
  }

  var body: some View {
    Form {
      // a hack to trigger live updates
      EmptyView()
        .onChange(of: style) { _ in
          StyleEditorView.statusBarView?.style = style.computedStyle()
          StyleEditorView.statusBarView?.window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
        }
        .onChange(of: style.animationType) { _ in
          presentDefault()
        }
        .onChange(of: text) { _ in
          NotificationPresenter.shared().updateText(text)
        }

      Section {
        buttonRow(title: "Present / Dismiss", subtitle: "Don't autohide.") {
          if NotificationPresenter.shared().isVisible() {
            NotificationPresenter.shared().dismiss(animated: true)
          } else {
            presentDefault()
          }
        }

        buttonRow(title: "Animate progress bar to 100%", subtitle: "Hides at 100%") {
          StyleEditorView.statusBarView = NotificationPresenter.shared().present(text: text, customStyle: style.registerComputedStyle()) { presenter in
            presenter.displayProgressBar(percentage: 1.0, animationDuration: 1.0) { presenter in
              presenter.dismiss(animated: true)
            }
          }
        }

        #if targetEnvironment(simulator)
          buttonRow(title: "Print style", subtitle: "Print current style config to \nthe console & copy it to the pasteboard.") {
            print(style.styleConfigurationString())
            UIPasteboard.general.string = style.styleConfigurationString()
          }
        #else
          buttonRow(title: "Copy style", subtitle: "Copy current style config to pasteboard") {
            UIPasteboard.general.string = style.styleConfigurationString()
          }
        #endif

        Toggle("Activity Indicator", isOn: $showActivity)
          .onChange(of: showActivity) { _ in
            if !NotificationPresenter.shared().isVisible() {
              presentDefault()
            } else {
              NotificationPresenter.shared().displayActivityIndicator(showActivity)
            }
          }.font(.subheadline)

        HStack {
          Text("Progress Bar (\(Int(round(progress * 100)))%)")
          Spacer()
          Slider(value: $progress)
            .frame(width: 150)
        }
        .onChange(of: progress) { _ in
          if !NotificationPresenter.shared().isVisible() {
            presentDefault()
          } else {
            NotificationPresenter.shared().displayProgressBar(percentage: progress)
          }
        }.font(.subheadline)

        HStack {
          Spacer()
          Text("Keep the notification presented to see any changes live!")
            .font(.caption2)
            .foregroundColor(.secondary)
          Spacer()
        }.disabled(true)
      }

      Section("Text") {
        TextField("Text", text: $text)
          .font(.subheadline)
        NavigationLink(destination: {
          FontPicker(font: $style.font)
        }, label: {
          HStack {
            Text("Font").font(.subheadline)
            Spacer()
            Text("\(style.font.fontDescriptor.postscriptName)")
              .font(.caption)
          }
        })

        Stepper("Font size (\(Int(style.font.pointSize)) pt)", value:
          Binding<CGFloat>(get: {
            style.font.pointSize
          }, set: { size in
            style.font = style.font.withSize(size)
          }), in: 5...36)
          .font(.subheadline)

        Stepper("Text Offset Y (\(Int(style.textOffsetY)))",
                value: $style.textOffsetY)
          .font(.subheadline)

        customColorPicker(title: "Text Color", binding: $style.textColor)

        buttonRow(title: "Add / remove text shadow") {
          if let _ = style.textShadowColor {
            style.textShadowColor = nil
          } else {
            style.textShadowColor = style.backgroundColor
          }
        }.foregroundColor(.primary)

        if let _ = style.textShadowColor {
          customColorPicker(title: "Text Shadow Color", binding: $style.textShadowColor)

          VStack(alignment: .leading, spacing: 6.0) {
            Text("Text Shadow Offset (\(Int(style.textShadowOffset.width))/\(Int(style.textShadowOffset.height)))")
              .font(.subheadline)
            HStack(alignment: .center, spacing: 20.0) {
              Spacer()
              Stepper("X:", value: $style.textShadowOffset.width)
                .frame(width: 120)
                .font(.subheadline)
              Stepper("Y:", value: $style.textShadowOffset.height)
                .frame(width: 120)
                .font(.subheadline)
              Spacer()
            }
          }
        }
      }

      Section("Notification Bar") {
        customColorPicker(title: "Background Color", binding: $style.backgroundColor)

        VStack(alignment: .leading) {
          Text("AnimationStyle").font(.subheadline)
          Picker("", selection: $style.animationType) {
            Text("None").tag(AnimationType.none)
            Text("Move").tag(AnimationType.move)
            Text("Fade").tag(AnimationType.fade)
            Text("Bounce").tag(AnimationType.bounce)
          }.font(.subheadline).pickerStyle(.segmented)
        }

        VStack(alignment: .leading) {
          Text("BackgroundStyle").font(.subheadline)
          Picker("", selection: $style.backgroundType) {
            Text("Classic").tag(BarBackgroundType.classic)
            Text("Pill").tag(BarBackgroundType.pill)
          }.font(.subheadline).pickerStyle(.segmented)
        }

        if style.backgroundType == .pill {
          Stepper("Pill height (\(Int(style.pillHeight)))",
                  value: $style.pillHeight,
                  in: 20...80)
            .font(.subheadline)

          Stepper("Pill Spacing Y (\(Int(style.pillSpacingY)))",
                  value: $style.pillSpacingY,
                  in: 0...99)
            .font(.subheadline)

          Stepper("Min Pill Width (\(Int(style.minimumPillWidth)))",
                  value: $style.minimumPillWidth,
                  in: 0...999)
            .font(.subheadline)
        }

        VStack(alignment: .leading) {
          Text("System StatusBar Style").font(.subheadline)
          Picker("", selection: $style.systemStatusBarStyle) {
            Text("Default").tag(StatusBarSystemStyle.default)
            Text("Light").tag(StatusBarSystemStyle.lightContent)
            Text("Dark").tag(StatusBarSystemStyle.darkContent)
          }.font(.subheadline).pickerStyle(.segmented)
        }

        VStack(alignment: .leading) {
          Text("Swipe to dismiss").font(.subheadline)
          Picker("", selection: $style.canSwipeToDismiss) {
            Text("Enabled").tag(true)
            Text("Disabled").tag(false)
          }.font(.subheadline).pickerStyle(.segmented)
        }
      }

      Section("Progress Bar") {
        customColorPicker(title: "Progress Bar Color", binding: $style.pbBarColor)

        Stepper("Bar height (\(Int(style.pbBarHeight)))",
                value: $style.pbBarHeight,
                in: 1...99)
          .font(.subheadline)

        VStack(alignment: .leading) {
          Text("Position").font(.subheadline)
          Picker("", selection: $style.pbPosition) {
            Text("Bottom").tag(ProgressBarPosition.bottom)
            Text("Center").tag(ProgressBarPosition.center)
            Text("Top").tag(ProgressBarPosition.top)
          }.font(.subheadline).pickerStyle(.segmented)
        }

        Stepper("Corner radius (\(Int(style.pbCornerRadius)))",
                value: $style.pbCornerRadius,
                in: 0...99)
          .font(.subheadline)

        Stepper("Bar Offset Y (\(Int(style.pbBarOffset)))",
                value: $style.pbBarOffset)
          .font(.subheadline)

        Stepper("Horizontal Insets (\(Int(style.pbHorizontalInsets)))",
                value: $style.pbHorizontalInsets,
                in: 0...999)
          .font(.subheadline)
      }
    }
  }

  func customColorPicker(title: String, binding: Binding<UIColor?>) -> some View {
    ColorPicker(title, selection: Binding<CGColor>(get: {
      binding.wrappedValue?.cgColor ?? UIColor.white.cgColor
    }, set: { val in
      binding.wrappedValue = UIColor(cgColor: val)
    }))
    .font(.subheadline)
  }

  func buttonRow(title: String, subtitle: String? = nil, action: @escaping () -> Void) -> some View {
    Button(action: action, label: {
      HStack {
        VStack(alignment: .leading) {
          Text(title)
            .font(.subheadline)
          if let subtitle = subtitle {
            Text(subtitle)
              .font(.caption)
              .foregroundColor(.secondary)
          }
        }
        Spacer()
        NavigationLink.empty
          .frame(width: 30.0)
      }
    })
  }
}

@available(iOS 15.0, *)
public struct FontPicker: UIViewControllerRepresentable {
  @Environment(\.presentationMode) var presentationMode
  @Binding var font: UIFont

  public init(font: Binding<UIFont>) {
    self._font = font
  }

  public func makeUIViewController(context: UIViewControllerRepresentableContext<FontPicker>) -> UIFontPickerViewController {
    let configuration = UIFontPickerViewController.Configuration()
    configuration.includeFaces = true
    let vc = UIFontPickerViewController(configuration: configuration)
    vc.delegate = context.coordinator
    vc.selectedFontDescriptor = context.coordinator.font.fontDescriptor
    return vc
  }

  public func makeCoordinator() -> FontPicker.Coordinator {
    return Coordinator(self, font: $font)
  }

  public class Coordinator: NSObject, UIFontPickerViewControllerDelegate {
    var parent: FontPicker
    @Binding var font: UIFont

    init(_ parent: FontPicker, font: Binding<UIFont>) {
      self.parent = parent
      self._font = font
    }

    public func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
      guard let descriptor = viewController.selectedFontDescriptor else { return }
      $font.wrappedValue = UIFont(descriptor: descriptor, size: font.pointSize)
      parent.presentationMode.wrappedValue.dismiss()
    }

    public func fontPickerViewControllerDidCancel(_ viewController: UIFontPickerViewController) {
      parent.presentationMode.wrappedValue.dismiss()
    }
  }

  public func updateUIViewController(_ uiViewController: UIFontPickerViewController,
                                     context: UIViewControllerRepresentableContext<FontPicker>) {}
}

@available(iOS 15.0, *)
struct StyleEditorView_Previews: PreviewProvider {
  static var previews: some View {
    StyleEditorView(text: "Initial Text", showActivity: true, progress: 0.33)
  }
}
