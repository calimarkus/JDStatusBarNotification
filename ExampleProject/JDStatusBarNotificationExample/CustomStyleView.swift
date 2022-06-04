//
//

import SwiftUI

@available(iOS 15.0, *)
class CustomStyleViewFactory: NSObject {
  @objc static func createCustomStyleView(presentationHandler: @escaping () -> Void) -> UIViewController {
    return UIHostingController(rootView: CustomStyleView())
  }
}

class CustomStyle: ObservableObject {
  @Published var barColor: UIColor? = .systemTeal
  @Published var textColor: UIColor? = .white
  @Published var textShadow: NSShadow? = nil
  @Published var font: UIFont = UIFont.systemFont(ofSize: 12.0)
  @Published var textVerticalPositionAdjustment: CGFloat = 0.0
  @Published var systemStatusBarStyle: StatusBarSystemStyle = .default
  @Published var animationType: AnimationType = .move
  @Published var canSwipeToDismiss: Bool = true

  @Published var pbBarColor: UIColor? = .orange
  @Published var pbBarHeight: CGFloat = 26.0
  @Published var pbPosition: ProgressBarPosition = .center
  @Published var pbHorizontalInsets: CGFloat = 20.0
  @Published var pbCornerRadius: CGFloat = 10.0

  func registerComputedStyle() -> String {
    let styleName = "custom"
    NotificationPresenter.shared().addStyle(styleName: styleName) { _ in
      computedStyle()
    }
    return styleName
  }

  func computedStyle() -> StatusBarStyle {
    let style = StatusBarStyle()
    style.barColor = barColor
    style.textColor = textColor
    style.textShadow = textShadow
    style.font = font
    style.textVerticalPositionAdjustment = textVerticalPositionAdjustment
    style.systemStatusBarStyle = systemStatusBarStyle
    style.animationType = animationType
    style.canSwipeToDismiss = canSwipeToDismiss
    style.progressBarStyle.barHeight = pbBarHeight
    style.progressBarStyle.position = pbPosition
    style.progressBarStyle.barColor = pbBarColor
    style.progressBarStyle.horizontalInsets = pbHorizontalInsets
    style.progressBarStyle.cornerRadius = pbCornerRadius
    return style
  }
}

@available(iOS 15.0, *)
struct CustomStyleView: View {
  @State var text: String = "You are doing great!"
  @StateObject var style: CustomStyle = .init()

  var body: some View {
    Form {
      buttonRow(title: "Present notification") {
        NotificationPresenter.shared()
          .present(text: text,
                   dismissAfterDelay: 2.0,
                   customStyle: style.registerComputedStyle())
      }

      buttonRow(title: "Present notification with progress") {
        NotificationPresenter.shared().present(text: text, customStyle: style.registerComputedStyle()) { presenter in
          presenter.displayProgressBar(percentage: 1.0, animationDuration: 1.0) { presenter in
            presenter.dismiss(animated: true)
          }
        }
      }

      HStack {
        Text("Preview:")
          .font(.subheadline)
        Spacer(minLength: 40.0)
        ZStack {
          Color(uiColor: style.barColor ?? .white)
            .cornerRadius(10.0)
          Text(text)
            .font(Font(.init(style.font.fontDescriptor, size: style.font.pointSize)))
            .foregroundColor(Color(uiColor: style.textColor ?? .black))
            .padding(.top, 12.0 + style.textVerticalPositionAdjustment / 2.0)
            .padding(.bottom, 12.0 - style.textVerticalPositionAdjustment / 2.0)
        }
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
          }))
          .font(.subheadline)

        customColorPicker(title: "Text Color", binding: $style.textColor)

        Stepper("Y-position adjustment (\(Int(style.textVerticalPositionAdjustment)))",
                value: $style.textVerticalPositionAdjustment)
          .font(.subheadline)

        Text("Text Shadow not customizable yet.")
          .font(.caption)
          .foregroundColor(.init(white: 0.0, opacity: 0.33))
          .disabled(true)
      }

      Section("Notification Bar") {
        customColorPicker(title: "Bar Color", binding: $style.barColor)

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
          Text("Swipe to dismiss").font(.subheadline)
          Picker("", selection: $style.canSwipeToDismiss) {
            Text("Enabled").tag(true)
            Text("Disabled").tag(false)
          }.font(.subheadline).pickerStyle(.segmented)
        }

        VStack(alignment: .leading) {
          Text("System StatusBar Style").font(.subheadline)
          Picker("", selection: $style.systemStatusBarStyle) {
            Text("Default").tag(StatusBarSystemStyle.default)
            Text("Light").tag(StatusBarSystemStyle.lightContent)
            Text("Dark").tag(StatusBarSystemStyle.darkContent)
          }.font(.subheadline).pickerStyle(.segmented)
        }
      }

      Section("Progress Bar") {
        customColorPicker(title: "Progress Bar Color", binding: $style.pbBarColor)

        VStack(alignment: .leading) {
          Text("Position").font(.subheadline)
          Picker("", selection: $style.pbPosition) {
            Text("Bottom").tag(ProgressBarPosition.bottom)
            Text("Center").tag(ProgressBarPosition.center)
            Text("Top").tag(ProgressBarPosition.top)
          }.font(.subheadline).pickerStyle(.segmented)
        }

        Stepper("Bar height (\(Int(style.pbBarHeight)))",
                value: $style.pbBarHeight)
          .font(.subheadline)

        Stepper("Horizontal Insets (\(Int(style.pbHorizontalInsets)))",
                value: $style.pbHorizontalInsets)
          .font(.subheadline)

        Stepper("Corner radius (\(Int(style.pbCornerRadius)))",
                value: $style.pbCornerRadius)
          .font(.subheadline)
      }
    }
  }

  func customColorPicker(title: String, binding: Binding<UIColor?>) -> some View {
    ColorPicker(title, selection: Binding<CGColor>(get: {
      binding.wrappedValue?.cgColor ?? UIColor.systemBlue.cgColor
    }, set: { val in
      binding.wrappedValue = UIColor(cgColor: val)
    }))
    .font(.subheadline)
  }

  func buttonRow(title: String, action: @escaping () -> Void) -> some View {
    Button(action: action, label: {
      HStack {
        Text(title)
          .font(.subheadline)
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
struct CustomStyleView_Previews: PreviewProvider {
  static var previews: some View {
    CustomStyleView()
  }
}
