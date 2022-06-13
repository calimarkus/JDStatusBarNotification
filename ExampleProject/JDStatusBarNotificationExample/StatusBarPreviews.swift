//
//

import SwiftUI

struct StatusBarPreview: UIViewRepresentable {
  var text: String
  var style: StatusBarStyle
  var progress: Double
  var activity: Bool

  init(_ text: String,
       progress: Double = 0.33,
       activity: Bool = true,
       style: ((StatusBarStyle) -> Void)? = nil)
  {
    self.text = text
    self.style = StatusBarStyle()
    self.progress = progress
    self.activity = activity
    if let style = style {
      style(self.style)
    }
  }

  func makeUIView(context: Context) -> UIView {
    let view = JDStatusBarView(style: self.style)
    view.text = self.text
    view.displaysActivityIndicator = self.activity
    view.progressBarPercentage = self.progress
    return view
  }

  func updateUIView(_ view: UIView, context: Context) {}
}

@available(iOS 15.0, *)
struct StatusBarPreview_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      StatusBarPreview("Full Width Style - Light") { style in
        style.backgroundStyle.backgroundType = .fullWidth
      }.frame(height: 66)

      StatusBarPreview("Full Width Style - Dark", progress: 0.88) { style in
        style.backgroundStyle.backgroundColor = .darkGray
        style.textStyle.textColor = .white
        style.backgroundStyle.backgroundType = .fullWidth
        style.progressBarStyle.barColor = .magenta
      }.frame(height: 66)

      StatusBarPreview("The quick brown fox jumps over the lazy dog. (Longer text test)",
                       progress: 0.0) { style in
        style.backgroundStyle.backgroundType = .fullWidth
      }.frame(height: 66)

      StatusBarPreview("Pill Style - Light").frame(height: 66)

      StatusBarPreview("Pill Style - Dark", progress: 0.88) { style in
        style.backgroundStyle.backgroundColor = .darkGray
        style.textStyle.textColor = .white
        style.progressBarStyle.barColor = .magenta
      }.frame(height: 66)

      StatusBarPreview("The quick brown fox jumps over the lazy dog. (Longer text test)",
                       progress: 0.0).frame(height: 66)

      Spacer()
    }
    .background(Color(uiColor: UIColor.systemGray5))
  }
}
