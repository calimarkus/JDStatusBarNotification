//
//

import SwiftUI

@available(iOS 15.0, *)
class StyleEditorViewFactory: NSObject {
  static let initialText = "You are doing great!"
  static let initialProgress = 0.33
  static let customStyle: CustomStyle = .init(StatusBarStyle())

  @objc static func createStyleEditorView() -> UIViewController {
    presentInitialNotification()
    return UIHostingController(rootView: StyleEditorView(text: initialText, showActivity: false, progress: initialProgress, style: customStyle))
  }

  static func presentInitialNotification() {
    StyleEditorView.statusBarView = NotificationPresenter.shared().present(text: initialText, customStyle: customStyle.registerComputedStyle(), completion: { presenter in
      presenter.animateProgressBar(toPercentage: initialProgress, animationDuration: 0.22)
    }) as? JDStatusBarView
  }
}

@available(iOS 15.0, *)
struct StyleEditorView: View {
  @State var text: String
  @State var subtitle: String = ""
  @State var showActivity: Bool
  @State var progress: Double
  @StateObject var style: CustomStyle

  weak static var statusBarView: JDStatusBarView? = nil

  func presentDefault() {
    StyleEditorView.statusBarView = NotificationPresenter.shared().present(
      title: text,
      subtitle: subtitle,
      customStyle: style.registerComputedStyle()
    ) as? JDStatusBarView

    if showActivity {
      NotificationPresenter.shared().displayActivityIndicator(true)
    }
    if progress > 0.0 {
      NotificationPresenter.shared().displayProgressBar(percentage: progress)
    }
  }

  func updateStyleOfPresentedView() {
    StyleEditorView.statusBarView?.style = style.computedStyle()
    StyleEditorView.statusBarView?.window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
  }

  var body: some View {
    Form {
      // a hack to trigger live updates
      EmptyView()
        .onChange(of: style) { _ in
          updateStyleOfPresentedView()
        }
        .onChange(of: style.animationType) { _ in
          presentDefault()
        }
        .onChange(of: text) { _ in
          NotificationPresenter.shared().updateText(text)
        }
        .onChange(of: subtitle) { _ in
          NotificationPresenter.shared().updateTitle(text, subtitle: subtitle)
        }

      Section {
        buttonRow(title: "Present / Dismiss", subtitle: "Don't autohide.") {
          if NotificationPresenter.shared().isVisible() {
            NotificationPresenter.shared().dismiss()
          } else {
            presentDefault()
          }
        }

        buttonRow(title: "Animate progress bar to 100%", subtitle: "Hides at 100%") {
          StyleEditorView.statusBarView = NotificationPresenter.shared().present(text: text, customStyle: style.registerComputedStyle()) { presenter in
            presenter.animateProgressBar(toPercentage: 1.0, animationDuration: style.backgroundType == .pill ? 0.66 : 1.2) { presenter in
              presenter.dismiss()
            }
          } as? JDStatusBarView
        }

        #if targetEnvironment(simulator)
          buttonRow(title: "Print style config", subtitle: "Print code to configure style to the console & copy it to the pasteboard.") {
            print(style.styleConfigurationString())
            UIPasteboard.general.string = style.styleConfigurationString()
          }
        #else
          buttonRow(title: "Copy style", subtitle: "Copy current style config to pasteboard") {
            UIPasteboard.general.string = style.styleConfigurationString()
          }
        #endif

        HStack {
          Spacer()
          Text("Keep the notification presented to see any changes live!")
            .font(.caption2)
            .foregroundColor(.secondary)
          Spacer()
        }.disabled(true)
      }

      Section("State") {
        VStack(alignment: .leading, spacing: 3.0) {
          Text("Title".uppercased())
            .font(.caption)
            .foregroundColor(.secondary)
          TextField("Empty", text: $text)
            .font(.subheadline)
        }

        VStack(alignment: .leading, spacing: 3.0) {
          Text("Subtitle".uppercased())
            .font(.caption)
            .foregroundColor(.secondary)
          TextField("Empty", text: $subtitle)
            .font(.subheadline)
        }

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
      }

      Section("Notification Bar Style") {
        OptionalColorViewFactory.buildPicker(title: "Background Color", binding: $style.backgroundColor)

        PickerFactory.build(title: "BarAnimationType", binding: $style.animationType) {
          EnumPickerOptionView(BarAnimationType.move)
          EnumPickerOptionView(BarAnimationType.fade)
          EnumPickerOptionView(BarAnimationType.bounce)
        }

        PickerFactory.build(title: "BarBackgroundType", binding: $style.backgroundType) {
          EnumPickerOptionView(BarBackgroundType.fullWidth)
          EnumPickerOptionView(BarBackgroundType.pill)
        }

        if style.backgroundType != .pill {
          PickerFactory.build(title: "StatusBarSystemStyle", binding: $style.systemStatusBarStyle) {
            EnumPickerOptionView(StatusBarSystemStyle.defaultStyle)
            EnumPickerOptionView(StatusBarSystemStyle.lightContent)
            EnumPickerOptionView(StatusBarSystemStyle.darkContent)
          }
        }

        VStack(alignment: .leading, spacing: 6.0) {
          PickerFactory.build(title: "Swipe to dismiss", binding: $style.canSwipeToDismiss) {
            Text("Enabled").tag(true)
            Text("Disabled").tag(false)
          }
        }
      }

      Section("Text Style") {
        TextStyleForm(style: style.textStyle, defaultShadowColor: style.backgroundColor) {
          updateStyleOfPresentedView()
        }
      }

      Section("Subtitle Style") {
        TextStyleForm(style: style.subtitleStyle, defaultShadowColor: style.backgroundColor) {
          updateStyleOfPresentedView()
        }
      }

      if style.backgroundType == .pill {
        Section("Pill background Style") {
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

          OptionalColorViewFactory.buildToggle(title: "Pill Border", binding: $style.pillBorderColor, defaultColor: .black)

          if let _ = style.pillBorderColor {
            OptionalColorViewFactory.buildPicker(title: "  Border Color", binding: $style.pillBorderColor)

            Stepper("  Border Width (\(Int(style.pillBorderWidth)))",
                    value: $style.pillBorderWidth,
                    in: 0...99)
              .font(.subheadline)
          }

          OptionalColorViewFactory.buildToggle(title: "Pill shadow", binding: $style.pillShadowColor, defaultColor: UIColor(white: 0.0, alpha: 0.33))

          if let _ = style.pillShadowColor {
            OptionalColorViewFactory.buildPicker(title: "  Shadow Color", binding: $style.pillShadowColor)

            Stepper("  Shadow Radius (\(Int(style.pillShadowRadius)))",
                    value: $style.pillShadowRadius,
                    in: 0...99)
              .font(.subheadline)

            CGSizeStepperFactory.build(title: "  Shadow Offset", binding: $style.pillShadowOffset)
          }
        }
      }

      Section("Left View Style") {
        Stepper("Spacing (\(Int(style.leftViewSpacing)))",
                value: $style.leftViewSpacing,
                in: 0...99)
          .font(.subheadline)

        VStack(alignment: .leading, spacing: 6.0) {
          Picker("Alignment", selection: $style.leftViewAlignment) {
            Group {
              EnumPickerOptionView(BarLeftViewAlignment.left)
              EnumPickerOptionView(BarLeftViewAlignment.centerWithText)
              EnumPickerOptionView(BarLeftViewAlignment.centerWithTextUnlessSubtitleExists)
            }.font(.caption)
          }.font(.subheadline)
        }
      }

      Section("Progress Bar Style") {
        OptionalColorViewFactory.buildPicker(title: "Progress Bar Color", binding: $style.pbBarColor)

        Stepper("Bar height (\(Int(style.pbBarHeight)))",
                value: $style.pbBarHeight,
                in: 1...99)
          .font(.subheadline)

        PickerFactory.build(title: "ProgressBarPosition", binding: $style.pbPosition) {
          EnumPickerOptionView(ProgressBarPosition.top)
          EnumPickerOptionView(ProgressBarPosition.center)
          EnumPickerOptionView(ProgressBarPosition.bottom)
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
              .lineLimit(3)
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
enum OptionalColorViewFactory {
  static func buildPicker(title: String, binding: Binding<UIColor?>) -> some View {
    ColorPicker(title, selection: Binding<CGColor>(get: {
      binding.wrappedValue?.cgColor ?? UIColor.white.cgColor
    }, set: { val in
      binding.wrappedValue = UIColor(cgColor: val)
    }))
    .font(.subheadline)
  }

  static func buildToggle(title: String, binding: Binding<UIColor?>, defaultColor: UIColor?) -> some View {
    Toggle(title, isOn: Binding(get: {
      binding.wrappedValue != nil
    }, set: { on in
      binding.wrappedValue = on ? defaultColor : nil
    }))
    .font(.subheadline)
  }
}

enum CGSizeStepperFactory {
  static func build(title: String, binding: Binding<CGSize>) -> some View {
    VStack(alignment: .leading, spacing: 6.0) {
      Text("\(title) (\(Int(binding.width.wrappedValue))/\(Int(binding.height.wrappedValue)))")
        .font(.subheadline)
      HStack(alignment: .center, spacing: 20.0) {
        Spacer()
        Stepper("X:", value: binding.width)
          .frame(width: 120)
          .font(.subheadline)
        Stepper("Y:", value: binding.height)
          .frame(width: 120)
          .font(.subheadline)
        Spacer()
      }
    }
  }
}

struct PickerFactory<T, SomeView> where T: Hashable, SomeView: View {
  static func build(title: String,
                    binding: Binding<T>,
                    @ViewBuilder content: () -> SomeView) -> some View
  {
    VStack(alignment: .leading, spacing: 6.0) {
      Text(title)
        .font(.subheadline)
        .padding(.top, 4.0)
      Picker("", selection: binding) {
        content()
      }.pickerStyle(.segmented)
    }
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
    StyleEditorView(text: "Initial Text", showActivity: true, progress: 0.33, style: CustomStyle(StatusBarStyle())).preferredColorScheme(.light)
    StyleEditorView(text: "Initial Text", showActivity: true, progress: 0.33, style: CustomStyle(StatusBarStyle())).preferredColorScheme(.dark)
  }
}
