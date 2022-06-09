//
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
class ExamplesViewFactory: NSObject {
  @objc static func createExamplesView(presentationHandler: @escaping () -> ()) -> UIViewController {
    presentInitialNotification()
    return UIHostingController(rootView: ExamplesView(customStylePresentationHandler: presentationHandler))
  }

  static func presentInitialNotification() {
    NotificationPresenter.shared().present(text: "👋 Hello World!",
                                           dismissAfterDelay: 2.5,
                                           includedStyle: IncludedStatusBarStyle.matrix)
  }
}

@available(iOS 15.0, *)
struct ExamplesView: View {
  static let customStyle1 = "Custom1"
  static let customStyle2 = "Custom2"

  let customStylePresentationHandler: () -> ()

  @State var progress = 0.0
  @State var showActivity = false
  @State var backgroundType: BarBackgroundType = .pill

  func showDefaultNotification(_ text: String, completion: @escaping (NotificationPresenter) -> ()) {
    let styleName = NotificationPresenter.shared().addStyle(styleName: "tmp", basedOnIncludedStyle: .default) { style in
      style.backgroundStyle.backgroundType = backgroundType
      return style
    }
    NotificationPresenter.shared().present(text: text, customStyle: styleName, completion: completion)
    if showActivity {
      NotificationPresenter.shared().displayActivityIndicator(true)
    }
    if progress > 0.0 {
      NotificationPresenter.shared().displayProgressBar(percentage: progress)
    }
  }

  func showIncludedStyle(_ text: String, style: IncludedStatusBarStyle) {
    let styleName = NotificationPresenter.shared().addStyle(styleName: "tmp", basedOnIncludedStyle: style) { style in
      style.backgroundStyle.backgroundType = backgroundType
      return style
    }
    NotificationPresenter.shared().present(text: text,
                                           dismissAfterDelay: 3.0,
                                           customStyle: styleName)
    if showActivity {
      NotificationPresenter.shared().displayActivityIndicator(true)
    }
    if progress > 0.0 {
      NotificationPresenter.shared().displayProgressBar(percentage: progress)
    }
  }

  var body: some View {
    List {
      Section {
        cell(title: "Style Editor", subtitle: "Get creative & create your own style!") {
          customStylePresentationHandler()
        }
      }

      Section("Default Style") {
        cell(title: "Present / dismiss", subtitle: "Default style, don't autohide") {
          if NotificationPresenter.shared().isVisible() {
            NotificationPresenter.shared().dismiss(animated: true)
          } else {
            showDefaultNotification("Better call Saul!") { _ in }
          }
        }
        cell(title: "Animate progress bar & hide", subtitle: "Hide bar at 100%") {
          if !NotificationPresenter.shared().isVisible() {
            showDefaultNotification("Animating Progress…") { presenter in
              presenter.animateProgressBar(toPercentage: 1.0, animationDuration: animationDurationForCurrentStyle()) { presenter in
                presenter.dismiss(animated: true)
              }
            }
            NotificationPresenter.shared().displayProgressBar(percentage: 0.0)
          } else {
            NotificationPresenter.shared().displayProgressBar(percentage: 0.0)
            NotificationPresenter.shared().animateProgressBar(toPercentage: 1.0, animationDuration: animationDurationForCurrentStyle()) { presenter in
              presenter.dismiss(animated: true)
            }
          }
        }
      }

      Section("Settings") {
        cell(title: "Update Text") {
          if !NotificationPresenter.shared().isVisible() {
            showDefaultNotification("") { _ in }
            NotificationPresenter.shared().dismiss(afterDelay: 2.0)
          }
          NotificationPresenter.shared().updateText("Updated Text…")
        }

        Toggle("Activity Indicator", isOn: $showActivity)
          .onChange(of: showActivity) { _ in
            if !NotificationPresenter.shared().isVisible() {
              if showActivity {
                showDefaultNotification("") { _ in }
                NotificationPresenter.shared().dismiss(afterDelay: 2.0)
              }
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
            if progress > 0.0 {
              showDefaultNotification("Making progress…") { _ in }
              NotificationPresenter.shared().dismiss(afterDelay: 2.0)
            }
          } else {
            NotificationPresenter.shared().displayProgressBar(percentage: progress)
          }
        }.font(.subheadline)

        VStack(alignment: .leading) {
          Text("BackgroundStyle").font(.subheadline)
          Picker("", selection: $backgroundType) {
            Text(BarBackgroundType.fullWidth.rawValue).tag(BarBackgroundType.fullWidth)
            Text(BarBackgroundType.pill.rawValue).tag(BarBackgroundType.pill)
          }.font(.subheadline).pickerStyle(.segmented)
        }
        .onChange(of: backgroundType) { _ in
          showDefaultNotification(backgroundType == .pill ? "Ohhh so shiny!" : "I prefer classic…") { _ in }
          NotificationPresenter.shared().dismiss(afterDelay: 2.0)
        }
      }

      Section("Included Styles") {
        includedStyleCell("Uh huh.", style: .default)
        includedStyleCell("It's time.", style: .light)
        includedStyleCell("Don't mess with me!", style: .dark)
        includedStyleCell("That's how we roll!", style: .success)
        includedStyleCell("You know who I am!", style: .warning)
        includedStyleCell("Uh oh, that didn't work..", style: .error)
        includedStyleCell("Wake up Neo…", style: .matrix)
      }

      Section("Custom Styles") {
        cell(title: "Present custom style 1", subtitle: "AnimationType.fade + Progress") {
          setupCustomStyles(backgroundType)
          NotificationPresenter.shared().present(text: "Oh, I love it!",
                                                 customStyle: ExamplesView.customStyle1) { presenter in
            presenter.animateProgressBar(toPercentage: 1.0, animationDuration: animationDurationForCurrentStyle()) { presenter in
              presenter.dismiss(animated: true)
            }
          }
        }

        cell(title: "Present custom style 2", subtitle: "AnimationType.bounce + Progress") {
          setupCustomStyles(backgroundType)
          NotificationPresenter.shared().present(text: "Level up!",
                                                 customStyle: ExamplesView.customStyle2) { presenter in
            presenter.animateProgressBar(toPercentage: 1.0, animationDuration: animationDurationForCurrentStyle()) { presenter in
              presenter.dismiss(animated: true)
            }
          }
        }

        cell(title: "Present notification with button", subtitle: "Manually customized view") {
          let styleName = NotificationPresenter.shared().addStyle(styleName: "tmp", basedOnIncludedStyle: .default) { style in
            style.backgroundStyle.backgroundType = .fullWidth
            return style
          }
          let view = NotificationPresenter.shared().present(text: "", customStyle: styleName)
          view.textLabel.removeFromSuperview()
          let action = UIAction { _ in
            NotificationPresenter.shared().dismiss(animated: true)
          }
          let button = UIButton(type: .system, primaryAction: action)
          button.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin]
          button.setTitle("Dismiss!", for: .normal)
          view.addSubview(button)
          button.sizeToFit()
          button.center = CGPoint(x: view.center.x, y: view.frame.size.height - button.frame.size.height / 2.0 - 2.0)
        }

        cell(title: "2 notifications in sequence", subtitle: "Utilizing the completion block") {
          showIncludedStyle("This is 1/2!", style: .dark)
          NotificationPresenter.shared().displayActivityIndicator(true)
          NotificationPresenter.shared().displayProgressBar(percentage: 0.0)
          NotificationPresenter.shared().dismiss(afterDelay: 1.0) { presenter in
            showIncludedStyle("✅ This is 2/2!", style: .dark)
            NotificationPresenter.shared().displayActivityIndicator(false)
            NotificationPresenter.shared().displayProgressBar(percentage: 0.0)
            presenter.dismiss(afterDelay: 1.0)
          }
        }
      }
    }
  }

  func cell(title: String, subtitle: String? = nil, action: @escaping () -> ()) -> some View {
    Button(action: action, label: {
      HStack {
        VStack(alignment: .leading) {
          Text(title)
            .font(.subheadline)
            .foregroundColor(.primary)
          if let subtitle = subtitle {
            Text(subtitle)
              .font(.caption2)
              .foregroundColor(.secondary)
          }
        }
        Spacer()
        NavigationLink.empty
          .frame(width: 30.0)
      }
    })
  }

  func includedStyleCell(_ text: String, style: IncludedStatusBarStyle) -> some View {
    cell(title: "Present \(style.rawValue)", subtitle: "Duration: 3s") {
      showIncludedStyle(text, style: style)
    }
  }

  func setupCustomStyles(_ backgroundType: BarBackgroundType) {
    NotificationPresenter.shared().addStyle(styleName: ExamplesView.customStyle1) { style in
      style.backgroundStyle.backgroundColor = UIColor(red: 0.797, green: 0.0, blue: 0.662, alpha: 1.0)
      style.backgroundStyle.backgroundType = backgroundType
      style.textStyle.textColor = .white
      style.animationType = .fade
      style.textStyle.font = UIFont(name: "SnellRoundhand-Bold", size: 17.0)!
      style.progressBarStyle.barColor = UIColor(red: 0.986, green: 0.062, blue: 0.598, alpha: 1.0)
      style.progressBarStyle.barHeight = 400.0
      style.progressBarStyle.cornerRadius = 0.0
      style.progressBarStyle.horizontalInsets = 0.0
      style.progressBarStyle.offsetY = 0.0
      return style
    }

    NotificationPresenter.shared().addStyle(styleName: ExamplesView.customStyle2) { style in
      style.backgroundStyle.backgroundColor = .cyan
      style.backgroundStyle.backgroundType = backgroundType
      style.textStyle.textColor = UIColor(red: 0.056, green: 0.478, blue: 0.998, alpha: 1.0)
      style.textStyle.textOffsetY = 3.0
      style.animationType = .bounce
      style.textStyle.font = UIFont(name: "DINCondensed-Bold", size: 17.0)!
      style.progressBarStyle.barColor = UIColor(white: 1.0, alpha: 0.66)
      style.progressBarStyle.barHeight = 6.0
      style.progressBarStyle.cornerRadius = 3.0
      style.progressBarStyle.horizontalInsets = 20.0
      style.progressBarStyle.position = .center
      return style
    }
  }

  func animationDurationForCurrentStyle() -> Double {
    switch backgroundType {
      case .pill:
        return 0.66
      case .fullWidth:
        fallthrough
      default:
        return 1.2
    }
  }
}

extension NavigationLink where Label == EmptyView, Destination == EmptyView {
  static var empty: NavigationLink {
    self.init(destination: EmptyView(), label: { EmptyView() })
  }
}

@available(iOS 15.0, *)
struct ExamplesView_Previews: PreviewProvider {
  static var previews: some View {
    ExamplesView {
      //
    }
  }
}
