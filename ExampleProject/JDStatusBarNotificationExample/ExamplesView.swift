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

  @State var showActivity: Bool = false
  @State var showProgress: Bool = false
  @State var usePillStyle: Bool = true

  func showDefaultNotification(_ text: String, completion: @escaping (NotificationPresenter) -> ()) {
    let styleName = NotificationPresenter.shared().addStyle(styleName: "tmp", basedOnIncludedStyle: .default) { style in
      style.backgroundStyle.backgroundType = usePillStyle ? .pill : .classic
      return style
    }
    NotificationPresenter.shared().present(text: text, customStyle: styleName, completion: completion)
    if showActivity {
      NotificationPresenter.shared().displayActivityIndicator(true)
    }
    if showProgress {
      NotificationPresenter.shared().displayProgressBar(percentage: 0.40)
    }
  }

  func showIncludedStyle(_ text: String, style: IncludedStatusBarStyle) {
    let styleName = NotificationPresenter.shared().addStyle(styleName: "tmp", basedOnIncludedStyle: style) { style in
      style.backgroundStyle.backgroundType = usePillStyle ? .pill : .classic
      return style
    }
    NotificationPresenter.shared().present(text: text,
                                           dismissAfterDelay: 3.0,
                                           customStyle: styleName)
    if showActivity {
      NotificationPresenter.shared().displayActivityIndicator(true)
    }
    if showProgress {
      NotificationPresenter.shared().displayProgressBar(percentage: 0.40)
    }
  }

  var body: some View {
    List {
      Section("Default Style") {
        cell(title: "Present / dismiss", subtitle: "Default style, don't autohide") {
          if NotificationPresenter.shared().isVisible() {
            NotificationPresenter.shared().dismiss(animated: true)
          } else {
            showDefaultNotification("Better call Saul!") { _ in }
          }
        }
        cell(title: "Animate ProgressBar & hide", subtitle: "Hide bar at 100%") {
          if !NotificationPresenter.shared().isVisible() {
            showDefaultNotification("Animating Progress…") { presenter in
              presenter.displayProgressBar(percentage: 0.0)
              presenter.displayProgressBar(percentage: 1.0, animationDuration: 1.0) { presenter in
                presenter.dismiss(animated: true)
              }
            }
          } else {
            NotificationPresenter.shared().displayProgressBar(percentage: 0.0)
            NotificationPresenter.shared().displayProgressBar(percentage: 1.0, animationDuration: 1.0) { presenter in
              presenter.dismiss(animated: true)
            }
          }
        }
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
                showDefaultNotification("On it…!") { _ in }
                NotificationPresenter.shared().dismiss(afterDelay: 2.0)
              }
            } else {
              NotificationPresenter.shared().displayActivityIndicator(showActivity)
            }
          }.font(.subheadline)

        Toggle("Progress Bar (33%)", isOn: $showProgress)
          .onChange(of: showProgress) { _ in
            if !NotificationPresenter.shared().isVisible() {
              if showProgress {
                showDefaultNotification("We're at 33%…") { _ in }
                NotificationPresenter.shared().dismiss(afterDelay: 2.0)
              }
            } else {
              NotificationPresenter.shared().displayProgressBar(percentage: showProgress ? 0.33 : 0.0)
            }
          }.font(.subheadline)

        Toggle("Use Pill Style", isOn: $usePillStyle)
          .onChange(of: usePillStyle) { _ in
            showDefaultNotification(usePillStyle ? "Ohhh so shiny!" : "I prefer classic…") { _ in }
            NotificationPresenter.shared().dismiss(afterDelay: 2.0)
          }.font(.subheadline)
      }

      Section("Included Styles") {
        cell(title: "Present .error", subtitle: "Duration: 3s") {
          showIncludedStyle("No, I don't have the money..", style: .error)
        }
        cell(title: "Present .warning", subtitle: "Duration: 3s") {
          showIncludedStyle("You know who I am!", style: .warning)
        }
        cell(title: "Present .success", subtitle: "Duration: 3s") {
          showIncludedStyle("That's how we roll!", style: .success)
        }
        cell(title: "Present .dark", subtitle: "Duration: 3s") {
          showIncludedStyle("Don't mess with me!", style: .dark)
        }
        cell(title: "Present .matrix", subtitle: "Duration: 3s") {
          showIncludedStyle("Wake up Neo…", style: .matrix)
        }
      }

      Section("Custom Styles") {
        cell(title: "Present custom style 1", subtitle: "AnimationType.fade + Progress") {
          setupCustomStyles(usePill: usePillStyle)
          NotificationPresenter.shared().present(text: "Oh, I love it!",
                                                 customStyle: ExamplesView.customStyle1) { presenter in
            presenter.displayProgressBar(percentage: 1.0, animationDuration: usePillStyle ? 0.66 : 1.2) { presenter in
              presenter.dismiss(animated: true)
            }
          }
        }

        cell(title: "Present custom style 2", subtitle: "AnimationType.bounce + Progress") {
          setupCustomStyles(usePill: usePillStyle)
          NotificationPresenter.shared().present(text: "Level up!",
                                                 customStyle: ExamplesView.customStyle2) { presenter in
            presenter.displayProgressBar(percentage: 1.0, animationDuration: usePillStyle ? 0.66 : 1.2) { presenter in
              presenter.dismiss(animated: true)
            }
          }
        }

        cell(title: "Present notification with button", subtitle: "Manually customized view") {
          let view = NotificationPresenter.shared().present(text: "")
          view.textLabel.removeFromSuperview()
          let action = UIAction { _ in
            NotificationPresenter.shared().dismiss(animated: true)
          }
          let button = UIButton(type: .system, primaryAction: action)
          button.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
          button.setTitle("Dismiss!", for: .normal)
          view.addSubview(button)
          button.sizeToFit()
          button.center = view.center
        }

        cell(title: "2 notifications in sequence", subtitle: "Utilizing the completion block") {
          showIncludedStyle("This is 1/2!", style: .dark)
          NotificationPresenter.shared().displayActivityIndicator(true)
          NotificationPresenter.shared().dismiss(afterDelay: 1.0) { presenter in
            showIncludedStyle("✅ This is 2/2!", style: .dark)
            presenter.dismiss(afterDelay: 1.0)
          }
        }
      }

      Section {
        cell(title: "Create your own style", subtitle: "Test all the possibilities…") {
          customStylePresentationHandler()
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

  func setupCustomStyles(usePill: Bool) {
    NotificationPresenter.shared().addStyle(styleName: ExamplesView.customStyle1) { style in
      style.backgroundStyle.backgroundColor = UIColor(red: 0.797, green: 0.0, blue: 0.662, alpha: 1.0)
      style.backgroundStyle.backgroundType = usePill ? .pill : .classic
      style.textStyle.textColor = .white
      style.animationType = .fade
      style.textStyle.font = UIFont(name: "SnellRoundhand-Bold", size: 17.0)!
      style.progressBarStyle.barColor = UIColor(red: 0.986, green: 0.062, blue: 0.598, alpha: 1.0)
      style.progressBarStyle.barHeight = 400.0
      return style
    }

    NotificationPresenter.shared().addStyle(styleName: ExamplesView.customStyle2) { style in
      style.backgroundStyle.backgroundColor = .cyan
      style.backgroundStyle.backgroundType = usePill ? .pill : .classic
      style.textStyle.textColor = UIColor(red: 0.056, green: 0.478, blue: 0.998, alpha: 1.0)
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
