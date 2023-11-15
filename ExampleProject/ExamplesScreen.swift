//
//

import Foundation
import JDStatusBarNotification
import SwiftUI

public class ExamplesScreenFactory: NSObject {
  @objc public static func createExamplesScreen(title: String) -> UIViewController {
    let text = "👋 Hello World!"
    NotificationPresenter.shared.present(text, includedStyle: .matrix, duration: 2.5)
    return UIHostingController(rootView:
      NavigationView {
        ExamplesScreen(title: title)
      }
    )
  }
}

struct ExamplesScreen: View {

  let title: String

  @State var progress = 0.0
  @State var showActivity = false
  @State var showSubtitle = false
  @State var backgroundType: StatusBarNotificationBackgroundType = .pill

  func showDefaultNotification(_ text: String, completion: @escaping (NotificationPresenter) -> ()) {
    let styleName = NotificationPresenter.shared.addStyle(named: "tmp", usingStyle: .defaultStyle) { style in
      style.backgroundStyle.backgroundType = backgroundType
      return style
    }
    NotificationPresenter.shared.present(text,
                                         subtitle: showSubtitle ? "{subtitle}" : nil,
                                         styleName: styleName,
                                         completion: completion)

    if showActivity {
      NotificationPresenter.shared.displayActivityIndicator(true)
    }
    if progress > 0.0 {
      NotificationPresenter.shared.displayProgressBar(at: progress)
    }
  }

  func showIncludedStyle(_ text: String, style: IncludedStatusBarNotificationStyle) {
    let styleName = NotificationPresenter.shared.addStyle(named: "tmp", usingStyle: style) { style in
      style.backgroundStyle.backgroundType = backgroundType
      return style
    }
    NotificationPresenter.shared.present(text, subtitle: showSubtitle ? "{subtitle}" : nil, styleName: styleName)
    NotificationPresenter.shared.dismiss(after: 3.0)

    if showActivity {
      NotificationPresenter.shared.displayActivityIndicator(true)
    }
    if progress > 0.0 {
      NotificationPresenter.shared.displayProgressBar(at: progress)
    }
  }

  var body: some View {
    List {
      Section {
        NavigationLink {
          StyleEditorScreen()
        } label: {
          VStack(alignment: .leading) {
            Text("Style Editor")
              .font(.subheadline)
              .foregroundColor(.accentColor)
            Text("Get creative & create your own style!")
              .font(.caption2)
              .foregroundColor(.secondary)
          }
        }.foregroundColor(.accentColor)
      }

      Section("Settings") {
        Text("These settings can be toggled before and during presentation of below examples.")
          .font(.caption)
          .foregroundStyle(.secondary)

        Toggle("Show subtitle", isOn: $showSubtitle)
          .onChange(of: showSubtitle) { on in
            if on, !NotificationPresenter.shared.isVisible {
              showDefaultNotification("Look!") { _ in }
              NotificationPresenter.shared.dismiss(after: 2.0)
            }
            NotificationPresenter.shared.updateSubtitle(on ? "I am a subtitle" : nil)
          }.font(.subheadline)

        Toggle("Activity Indicator", isOn: $showActivity)
          .onChange(of: showActivity) { _ in
            if !NotificationPresenter.shared.isVisible {
              if showActivity {
                let styleName = NotificationPresenter.shared.addStyle(named: "tmp", usingStyle: .defaultStyle) { style in
                  style.backgroundStyle.backgroundType = backgroundType
                  style.backgroundStyle.pillStyle.minimumWidth = 0.0
                  return style
                }
                NotificationPresenter.shared.present("", styleName: styleName, duration: 2.0)
                NotificationPresenter.shared.displayActivityIndicator(true)
              }
            } else {
              NotificationPresenter.shared.displayActivityIndicator(showActivity)
            }
          }.font(.subheadline)

        HStack {
          Text("Progress Bar (\(Int(round(progress * 100)))%)")
          Spacer()
          Slider(value: $progress)
            .frame(width: 150)
        }
        .onChange(of: progress) { _ in
          if !NotificationPresenter.shared.isVisible {
            if progress > 0.0 {
              showDefaultNotification("Making progress…") { _ in }
              NotificationPresenter.shared.dismiss(after: 2.0)
            }
          } else {
            NotificationPresenter.shared.displayProgressBar(at: progress)
          }
        }.font(.subheadline)

        VStack(alignment: .leading, spacing: 6.0) {
          Text("Background Type")
            .font(.subheadline)
          Picker("", selection: $backgroundType) {
            EnumPickerOptionView(StatusBarNotificationBackgroundType.pill)
            EnumPickerOptionView(StatusBarNotificationBackgroundType.fullWidth)
          }.font(.subheadline).pickerStyle(.segmented)
        }
        .onChange(of: backgroundType) { _ in
          showDefaultNotification(backgroundType == .pill ? "Ohhh so shiny!" : "I prefer classic…") { _ in }
          NotificationPresenter.shared.dismiss(after: 2.0)
        }
      }

      Section("Included Styles") {
        includedStyleCell("Uh huh.", style: .defaultStyle)
        includedStyleCell("It's time.", style: .light)
        includedStyleCell("Don't mess with me!", style: .dark)
        includedStyleCell("That's how we roll!", style: .success)
        includedStyleCell("You know who I am!", style: .warning)
        includedStyleCell("Uh oh, that didn't work..", style: .error)
        includedStyleCell("Wake up Neo…", style: .matrix)
      }

      Section("SwiftUI Examples") {
        Text("These ignore above settings except the Background Type.")
          .font(.caption)
          .foregroundStyle(.secondary)

        cell(title: "Simple text", subtitle: "Display a SwiftUI text, 2.5s") {
          let styleName = NotificationPresenter.shared.addStyle(named: "tmp", usingStyle: .defaultStyle) { style in
            style.backgroundStyle.backgroundType = backgroundType
            style.backgroundStyle.backgroundColor = .systemMint
            style.backgroundStyle.pillStyle.minimumWidth = 20.0
            return style
          }

          NotificationPresenter.shared.presentSwiftView(styleName: styleName) {
            Text("👋 This is SwiftUI!")
              .font(.caption.bold())
              .padding([.leading, .trailing], 20.0)
              .fixedSize()
          }

          NotificationPresenter.shared.dismiss(after: 2.5)
        }

        cell(title: "Two row layout + Icon", subtitle: "Display SwiftUI text & image, 2.5s") {
          let styleName = NotificationPresenter.shared.addStyle(named: "tmp", usingStyle: .defaultStyle) { style in
            style.backgroundStyle.backgroundType = backgroundType
            style.backgroundStyle.backgroundColor = .systemIndigo
            style.backgroundStyle.pillStyle.minimumWidth = 20.0
            return style
          }

          NotificationPresenter.shared.presentSwiftView(styleName: styleName) {
            HStack {
              Spacer()

              Image(systemName: "swift")
                .foregroundColor(.white)

              Spacer()
                .frame(width: 10.0)

              VStack(alignment: .leading, spacing: 0.0) {
                Text("Swift Views!")
                  .font(.caption.bold())
                  .foregroundColor(.white)
                Text("Easy custom layouts")
                  .font(.caption)
                  .foregroundColor(.white.opacity(0.5))
                  .lineLimit(1)
              }

              Spacer()
            }
            .padding([.leading, .trailing], 20.0)
            .fixedSize()
          }

          NotificationPresenter.shared.dismiss(after: 2.5)
        }

        if #available(iOS 16.0, *) { // Gradient is iOS 16+
          cell(title: "Gradient & Icon", subtitle: "A custom SwiftUI background, 2.5s") {
            let styleName = NotificationPresenter.shared.addStyle(named: "tmp", usingStyle: .defaultStyle) { style in
              style.backgroundStyle.backgroundType = backgroundType
              style.backgroundStyle.backgroundColor = UIColor(.orange)
              style.backgroundStyle.pillStyle.minimumWidth = 20.0
              return style
            }

            NotificationPresenter.shared.presentSwiftView(styleName: styleName) {
              let inner = VStack {
                Spacer()
                Image(systemName: "swift")
                  .foregroundStyle(.white)
                Spacer()
              }.padding([.leading, .trailing], 14.0)

              Group {
                if backgroundType == .fullWidth {
                  HStack {
                    Spacer()
                    inner
                    Spacer()
                  }
                } else {
                  inner
                }
              }
              .background(Gradient(colors: [.orange, .red]))
            }

            NotificationPresenter.shared.dismiss(after: 2.5)
          }
        }
      }

      Section("Custom Style Examples") {
        Text("These include a progress bar animation.")
          .font(.caption)
          .foregroundStyle(.secondary)

        customStyleCell("Love it!", subtitle: "AnimationType.fade + Progress", style: .loveIt)
        customStyleCell("Level Up!", subtitle: "AnimationType.bounce + Progress", style: .levelUp)
        customStyleCell("Looks good", subtitle: "Subtitle + Activity", style: .looksGood)
        customStyleCell("Small Pill", subtitle: "Modified pill size + Progress", style: .smallPill)
        customStyleCell("Style Editor Style", subtitle: "Subtitle + Progress", style: .editor)
      }

      Section("Custom View Examples") {
        cell(title: "Present a button", subtitle: "A custom notification view") {
          // create button
          let button = UIButton(type: .system, primaryAction: UIAction { _ in
            NotificationPresenter.shared.dismiss()
          })
          button.setTitle("Dismiss!", for: .normal)

          // present
          let styleName = NotificationPresenter.shared.addStyle(named: "tmp", usingStyle: .defaultStyle) { style in
            style.backgroundStyle.backgroundType = backgroundType
            style.canTapToHold = false // this ensure the button can receive touches
            return style
          }
          NotificationPresenter.shared.presentCustomView(button, styleName: styleName)
        }

        cell(title: "Present custom left icon", subtitle: "A custom left view, 2.5s") {
          // create icon
          let image = UIImageView(image: UIImage(systemName: "gamecontroller.fill"))

          // present
          ExampleStyle.iconLeftView.register(for: backgroundType)
          NotificationPresenter.shared.present("Player II", subtitle: "Connected", styleName: ExampleStyle.iconLeftView.rawValue)
          NotificationPresenter.shared.displayLeftView(image)
          NotificationPresenter.shared.dismiss(after: 2.5)
        }
      }

      Section("Sequencing Example") {
        cell(title: "2 notifications in sequence", subtitle: "Utilizing the completion block, 2 x 1s") {
          showIncludedStyle("This is 1/2!", style: .dark)
          NotificationPresenter.shared.displayActivityIndicator(true)
          NotificationPresenter.shared.displayProgressBar(at: 0.0)
          NotificationPresenter.shared.dismiss(after: 1.0) { presenter in
            showIncludedStyle("✅ This is 2/2!", style: .dark)
            NotificationPresenter.shared.displayActivityIndicator(false)
            NotificationPresenter.shared.displayProgressBar(at: 0.0)
            presenter.dismiss(after: 1.0)
          }
        }
      }
    }
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.inline)
  }

  func cell(title: String, subtitle: String? = nil, useAccentColor: Bool = false, action: @escaping () -> ()) -> some View {
    Button(action: action, label: {
      HStack {
        VStack(alignment: .leading) {
          Text(title)
            .font(.subheadline)
            .foregroundColor(useAccentColor ? .accentColor : .primary)
          if let subtitle = subtitle {
            Text(subtitle)
              .font(.caption2)
              .foregroundColor(.secondary)
          }
        }
        Spacer()

        // a hack to get disclosure icons on these table rows
        NavigationLink.empty
          .frame(width: 30.0)
          .foregroundColor(useAccentColor ? .accentColor : .secondary)
      }
    })
  }

  func includedStyleCell(_ text: String, style: IncludedStatusBarNotificationStyle) -> some View {
    cell(title: "Present \(style.stringValue)", subtitle: "Duration: 3s") {
      showIncludedStyle(text, style: style)
    }
  }

  func customStyleCell(_ title: String, subtitle: String? = nil, style: ExampleStyle) -> some View {
    let content = style.exampleContent
    return cell(title: "Present: \(title)", subtitle: subtitle) {
      style.register(for: backgroundType)
      NotificationPresenter.shared.present(content.title, subtitle: content.subtitle, styleName: style.rawValue) { presenter in
        presenter.animateProgressBar(to: 1.0, duration: animationDurationForCurrentStyle()) { presenter in
          presenter.dismiss()
        }
      }
      NotificationPresenter.shared.displayActivityIndicator(showActivity)
    }
  }

  func animationDurationForCurrentStyle() -> Double {
    switch backgroundType {
      case .pill:
        return 0.75
      case .fullWidth:
        fallthrough
      default:
        return 1.25
    }
  }
}

extension NavigationLink where Label == EmptyView, Destination == EmptyView {
  static var empty: NavigationLink {
    self.init(destination: EmptyView(), label: { EmptyView() })
  }
}

struct ExamplesScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      ExamplesScreen(title: "ExampleScreen")
    }
  }
}
