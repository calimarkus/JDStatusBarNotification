//
//

import SwiftUI

fileprivate struct StatusBarPreviewView: UIViewRepresentable {
  var title: String?
  var subtitle: String?
  var style: StatusBarNotificationStyle
  var progress: Double
  var activity: Bool

  internal init(_ title: String?, subtitle: String?, progress: Double, activity: Bool) {
    self.title = title
    self.subtitle = subtitle
    self.style = StatusBarNotificationStyle()
    self.progress = progress
    self.activity = activity
  }

  init(_ title: String? = nil,
       subtitle: String? = nil,
       progress: Double = 0.0,
       activity: Bool = false,
       style: ((StatusBarNotificationStyle) -> Void)? = nil)
  {
    self.init(title, subtitle: subtitle, progress: progress, activity: activity)
    if let style = style {
      style(self.style)
    }
  }

  func makeUIView(context: Context) -> UIView {
    let view = NotificationView()
    view.title = self.title
    view.subtitle = self.subtitle
    view.style = self.style
    view.displaysActivityIndicator = self.activity
    view.progressBarPercentage = self.progress
    return view
  }

  func updateUIView(_ view: UIView, context: Context) {}
}

@available(iOS 15.0, *)
struct StatusBarPreviewView_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 8.0) {
      StatusBarPreviewView("Full Width Style - Light") { style in
        style.backgroundStyle.backgroundType = .fullWidth
      }
      .frame(height: 100)

      StatusBarPreviewView("Full Width Style - Dark", subtitle: "Test", progress: 0.88, activity: true) { style in
        style.backgroundStyle.backgroundColor = .darkGray
        style.textStyle.textColor = .white
        style.backgroundStyle.backgroundType = .fullWidth
        style.progressBarStyle.barColor = .magenta
        style.progressBarStyle.offsetY = 0.0
        style.progressBarStyle.horizontalInsets = 0.0
      }.frame(height: 100)

      StatusBarPreviewView("Pill Style - Light", subtitle: "Test II") { style in
        style.progressBarStyle.offsetY = 0.0
      }.frame(height: 50)

      StatusBarPreviewView("Pill Style - Dark", progress: 0.88, activity: true) { style in
        style.backgroundStyle.backgroundColor = .darkGray
        style.textStyle.textColor = .white
        style.progressBarStyle.barColor = .magenta
      }.frame(height: 50)

      StatusBarPreviewView("The quick brown fox jumps over the lazy dog. (Longer text test)",
                           progress: 1.0) { style in
        style.progressBarStyle.offsetY = 0.0
        style.progressBarStyle.horizontalInsets = 10.0
      }.frame(height: 50)

      StatusBarPreviewView("FYI", subtitle: "Short one.",
                           progress: 1.0) { style in
        style.progressBarStyle.offsetY = 0.0
        style.progressBarStyle.horizontalInsets = 10.0
      }.frame(height: 50)

      StatusBarPreviewView("Title", subtitle: "The quick brown fox jumps over the lazy dog. (Longer text test)") { style in
        style.progressBarStyle.offsetY = 0.0
      }.frame(height: 50)

      StatusBarPreviewView("Title", subtitle: "The quick brown fox jumps over the lazy dog. (Longer text test)", activity: true) { style in
        style.progressBarStyle.offsetY = 0.0
      }.frame(height: 50)

      StatusBarPreviewView("The quick brown fox jumps over the lazy dog. (Longer text test)", subtitle: "Short one", activity: true) { style in
        style.progressBarStyle.offsetY = 0.0
      }.frame(height: 50)

      StatusBarPreviewView("Short one", subtitle: "The quick brown fox jumps over the lazy dog. (Longer text test)", activity: true) { style in
        style.progressBarStyle.offsetY = 0.0
      }.frame(height: 50)

      StatusBarPreviewView("Short one", activity: true) { style in
        style.progressBarStyle.offsetY = 0.0
      }.frame(height: 50)

      Spacer()
    }
    .background(Color(uiColor: UIColor.systemGray5))
    .ignoresSafeArea()
  }
}
