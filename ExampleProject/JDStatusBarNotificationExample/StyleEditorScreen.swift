//
//

import SwiftUI

@available(iOS 15.0, *)
struct StyleEditorScreen: View {
  @State var text: String = "You're great!"
  @State var subtitle: String = "I mean it"
  @State var showActivity: Bool = false
  @State var progress: Double = 0.5
  @StateObject var style: ObservableCustomStyle = .init(ExampleStyle.editor.buildStyle())
  @State var editingTitle: Bool = true

  weak static var statusBarView: JDStatusBarView? = nil

  func presentDefault(allowActivity: Bool = true, allowProgress: Bool = true, completion: @escaping () -> Void) {
    StyleEditorScreen.statusBarView = NotificationPresenter.shared().present(
      title: text,
      subtitle: subtitle,
      customStyle: style.registerComputedStyle()
    ) { _ in
      completion()
    } as? JDStatusBarView

    if allowActivity && showActivity {
      NotificationPresenter.shared().displayActivityIndicator(true)
    }
    if allowProgress && progress > 0.0 {
      NotificationPresenter.shared().displayProgressBar(percentage: progress)
    }
  }

  func updateStyleOfPresentedView() {
    StyleEditorScreen.statusBarView?.style = style.computedStyle()
    StyleEditorScreen.statusBarView?.window?.rootViewController?.setNeedsStatusBarAppearanceUpdate()
  }

  var body: some View {
    Form {
      // a hack to trigger live updates
      EmptyView()
        .onChange(of: style) { _ in
          updateStyleOfPresentedView()
        }
        .onChange(of: style.animationType) { _ in
          presentDefault {}
        }
        .onChange(of: text) { _ in
          NotificationPresenter.shared().updateText(text)
        }
        .onChange(of: subtitle) { _ in
          NotificationPresenter.shared().updateSubtitle(subtitle)
        }

      Section {
        buttonRow(title: "Present / Dismiss", subtitle: "Don't autohide.") {
          if NotificationPresenter.shared().isVisible() {
            NotificationPresenter.shared().dismiss()
          } else {
            presentDefault {}
          }
        }

        buttonRow(title: "Animate progress (0% to 100%)", subtitle: "Hides at 100%") {
          if !NotificationPresenter.shared().isVisible() {
            presentDefault(allowProgress: false) {
              NotificationPresenter.shared().animateProgressBar(toPercentage: 1.0, animationDuration: style.backgroundType == .pill ? 0.66 : 1.2) { presenter in
                presenter.dismiss()
              }
            }
          } else {
            NotificationPresenter.shared().displayProgressBar(percentage: 0.0)
            NotificationPresenter.shared().animateProgressBar(toPercentage: 1.0, animationDuration: style.backgroundType == .pill ? 0.66 : 1.2) { presenter in
              presenter.dismiss()
            }
          }
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
            .multilineTextAlignment(.center)
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
              presentDefault {}
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
            presentDefault {}
          } else {
            NotificationPresenter.shared().displayProgressBar(percentage: progress)
          }
        }.font(.subheadline)
      }

      Section("Bar Style") {
        OptionalColorPicker(title: "Background Color", color: $style.backgroundColor)

        SegmentedPicker(title: "BarAnimationType", value: $style.animationType) {
          EnumPickerOptionView(BarAnimationType.bounce)
          EnumPickerOptionView(BarAnimationType.move)
          EnumPickerOptionView(BarAnimationType.fade)
        }

        SegmentedPicker(title: "BarBackgroundType", value: $style.backgroundType) {
          EnumPickerOptionView(BarBackgroundType.pill)
          EnumPickerOptionView(BarBackgroundType.fullWidth)
        }

        if style.backgroundType != .pill {
          SegmentedPicker(title: "StatusBarSystemStyle", value: $style.systemStatusBarStyle) {
            EnumPickerOptionView(StatusBarSystemStyle.defaultStyle)
            EnumPickerOptionView(StatusBarSystemStyle.lightContent)
            EnumPickerOptionView(StatusBarSystemStyle.darkContent)
          }
        }

        SegmentedPicker(title: "Swipe to dismiss", value: $style.canSwipeToDismiss) {
          Text("Enabled").tag(true)
          Text("Disabled").tag(false)
        }

        SegmentedPicker(title: "Dismissal during taps/pans", value: $style.canDismissDuringUserInteraction) {
          Text("Enabled").tag(true)
          Text("Disabled").tag(false)
        }
      }

      Section("Text Style") {
        SegmentedPicker(title: "", value: $editingTitle) {
          Text("Title").tag(true)
          Text("Subtitle").tag(false)
        }
        if editingTitle {
          TextStyleEditorView(title: "Title", style: style.textStyle, defaultShadowColor: style.backgroundColor) {
            updateStyleOfPresentedView()
          }
        } else {
          TextStyleEditorView(title: "Subtitle", style: style.subtitleStyle, defaultShadowColor: style.backgroundColor) {
            updateStyleOfPresentedView()
          }
        }
      }

      if style.backgroundType == .pill {
        Section("Pill Style") {
          TextFieldStepper(title: "Pill Height", binding: $style.pillHeight, range: 20...80)
          TextFieldStepper(title: "Pill Spacing Y", binding: $style.pillSpacingY, range: 0...99)
          TextFieldStepper(title: "Min Pill Width", binding: $style.minimumPillWidth, range: 0...999)

          OptionalColorToggle(title: "Pill Border", color: $style.pillBorderColor, defaultColor: .black)
          if let _ = style.pillBorderColor {
            OptionalColorPicker(title: "  Border Color", color: $style.pillBorderColor)
            TextFieldStepper(title: "  Border Width", binding: $style.pillBorderWidth, range: 0...20)
          }

          OptionalColorToggle(title: "Pill shadow", color: $style.pillShadowColor, defaultColor: UIColor(white: 0.0, alpha: 0.33))
          if let _ = style.pillShadowColor {
            OptionalColorPicker(title: "  Shadow Color", color: $style.pillShadowColor)
            TextFieldStepper(title: "  Shadow Radius", binding: $style.pillShadowRadius, range: 0...99)
            CGSizeStepper(title: "  Shadow Offset", size: $style.pillShadowOffset)
          }
        }
      }

      Section("Left View Style") {
        TextFieldStepper(title: "Spacing", binding: $style.leftViewSpacing, range: 0...99)
        TextFieldStepper(title: "Offset X", binding: $style.leftViewOffsetX, range: -99...99)

        SegmentedPicker(title: "Alignment", value: $style.leftViewAlignment) {
          EnumPickerOptionView(BarLeftViewAlignment.left)
          EnumPickerOptionView(BarLeftViewAlignment.centerWithText)
        }

        HStack {
          Spacer()
          Text("The activity indicator is also considered a \"left view\" and thus also affected by these settings.")
            .font(.caption2)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
          Spacer()
        }.disabled(true)
      }

      Section("Progress Bar Style") {
        OptionalColorPicker(title: "Progress Bar Color", color: $style.pbBarColor)

        TextFieldStepper(title: "Bar height", binding: $style.pbBarHeight, range: 1...99)
          .onChange(of: style.pbBarHeight) { val in
            if style.pbCornerRadius > 0.0 {
              style.pbCornerRadius = floor(val / 2.0)
            }
          }

        TextFieldStepper(title: "Corner radius", binding: $style.pbCornerRadius, range: 0...99)
        TextFieldStepper(title: "Bar Offset Y", binding: $style.pbBarOffset, range: -99...99)
        TextFieldStepper(title: "Horizontal Insets", binding: $style.pbHorizontalInsets, range: 0...99)

        SegmentedPicker(title: "ProgressBarPosition", value: $style.pbPosition) {
          EnumPickerOptionView(ProgressBarPosition.top)
          EnumPickerOptionView(ProgressBarPosition.center)
          EnumPickerOptionView(ProgressBarPosition.bottom)
        }
      }
    }
    .navigationBarTitle("Style Editor")
    .onAppear {
      presentDefault {}
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
struct StyleEditorView_Previews: PreviewProvider {
  static var previews: some View {
    StyleEditorScreen().preferredColorScheme(.light)
    StyleEditorScreen().preferredColorScheme(.dark)
  }
}
