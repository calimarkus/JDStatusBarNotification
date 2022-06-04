//
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
class ExamplesViewFactory: NSObject {
  @objc static func createExamplesView(presentationHandler: @escaping () -> ()) -> UIViewController {
    setupCustomStyles()
    presentInitialNotification()
    return UIHostingController(rootView: ExamplesView(customStylePresentationHandler: presentationHandler))
  }

  static func setupCustomStyles() {
    NotificationPresenter.shared().addStyle(styleName: ExamplesView.customStyle1) { style in
      style.barColor = UIColor(red: 0.797, green: 0.0, blue: 0.662, alpha: 1.0)
      style.textColor = .white
      style.animationType = .fade
      style.font = UIFont(name: "SnellRoundhand-Bold", size: 17.0)!
      style.progressBarStyle.barColor = UIColor(red: 0.986, green: 0.062, blue: 0.598, alpha: 1.0)
      style.progressBarStyle.barHeight = 400.0
      return style
    }

    NotificationPresenter.shared().addStyle(styleName: ExamplesView.customStyle2) { style in
      style.barColor = .cyan
      style.textColor = UIColor(red: 0.056, green: 0.478, blue: 0.998, alpha: 1.0)
      style.animationType = .bounce
      style.font = UIFont(name: "DINCondensed-Bold", size: 17.0)!
      style.progressBarStyle.barColor = UIColor(white: 1.0, alpha: 0.66)
      style.progressBarStyle.barHeight = 6.0
      style.progressBarStyle.cornerRadius = 3.0
      style.progressBarStyle.horizontalInsets = 20.0
      style.progressBarStyle.position = .center
      return style
    }
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

  func showDefaultNotificationIfNotPresented(_ text: String) {
    if !NotificationPresenter.shared().isVisible() {
      NotificationPresenter.shared().present(text: text)
    }
  }

  func showIncludedStyle(_ text: String, style: IncludedStatusBarStyle) {
    NotificationPresenter.shared().present(text: text,
                                           dismissAfterDelay: 3.0,
                                           includedStyle: style)
  }

  var body: some View {
    List {
      Section("Default Style") {
        cell(title: "Show Notification", subtitle: "Don't autohide") {
          showDefaultNotificationIfNotPresented("Better call Saul!")
        }
        cell(title: "Animate ProgressBar & hide", subtitle: "Hide bar at 100%") {
          showDefaultNotificationIfNotPresented("Animating Progress…")
          NotificationPresenter.shared().displayProgressBar(percentage: 0.0)
          NotificationPresenter.shared().displayProgressBar(percentage: 1.0, animationDuration: 1.0) { presenter in
            presenter.dismiss(animated: true)
          }
        }
        cell(title: "Show ProgressBar at 33%") {
          showDefaultNotificationIfNotPresented("1/3 done.")
          NotificationPresenter.shared().displayProgressBar(percentage: 0.33)
        }
        cell(title: "Show Activity Indicator") {
          showDefaultNotificationIfNotPresented("Some Activity…")
          NotificationPresenter.shared().displayActivityIndicator(true)
        }
        cell(title: "Update Text") {
          showDefaultNotificationIfNotPresented("")
          NotificationPresenter.shared().updateText("Updated Text…")
        }
        cell(title: "Dismiss Notification") {
          NotificationPresenter.shared().dismiss(animated: true)
        }
      }

      Section("Included Styles") {
        cell(title: "Show .error", subtitle: "Duration: 3s") {
          showIncludedStyle("No, I don't have the money..", style: .error)
        }
        cell(title: "Show .warning", subtitle: "Duration: 3s") {
          showIncludedStyle("You know who I am!", style: .warning)
        }
        cell(title: "Show .success", subtitle: "Duration: 3s") {
          showIncludedStyle("That's how we roll!", style: .success)
        }
        cell(title: "Show .dark", subtitle: "Duration: 3s") {
          showIncludedStyle("Don't mess with me!", style: .dark)
        }
        cell(title: "Show .matrix", subtitle: "Duration: 3s") {
          showIncludedStyle("Wake up Neo…", style: .matrix)
        }
      }

      Section("Custom Styles") {
        cell(title: "Show custom style 1", subtitle: "AnimationType.fade + Progress") {
          NotificationPresenter.shared().present(text: "Oh, I love it!",
                                                 customStyle: ExamplesView.customStyle1) { presenter in
            presenter.displayProgressBar(percentage: 1.0, animationDuration: 1.5) { presenter in
              presenter.dismiss(animated: true)
            }
          }
        }

        cell(title: "Show custom style 2", subtitle: "AnimationType.bounce + Progress") {
          NotificationPresenter.shared().present(text: "Level up!",
                                                 customStyle: ExamplesView.customStyle2) { presenter in
            presenter.displayProgressBar(percentage: 1.0, animationDuration: 1.5) { presenter in
              presenter.dismiss(animated: true)
            }
          }
        }

        cell(title: "Show notification with button", subtitle: "Manually customized view") {
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
