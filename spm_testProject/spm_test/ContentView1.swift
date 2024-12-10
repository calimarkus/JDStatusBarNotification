//
//

import JDStatusBarNotification
import SwiftUI

extension NotificationPresenter {
  func addStyleForIncludedStyle(_ style: IncludedStatusBarNotificationStyle) -> String {
    return addStyle(named: "example-style", usingStyle: style) { $0 }
  }
}

struct ContentView1: View {

  @State var isPresented: Bool = false

  var body: some View {
    let presenter = NotificationPresenter.shared

    List {
      Section("Classic Presentation") {
        Button("The rabbit (1.5s)") {
          presenter.present("Follow the white rabbit!", includedStyle: .matrix, duration: 1.5)
        }
      }

      Section("Swift style Presentation") {
        Button("Classic-Swift (1.5s)") {
          presenter.presentSwiftView(styleName: presenter.addStyleForIncludedStyle(.dark)) {
            HelloSPMView(title: "Now also working in SPM.")
          }
          presenter.dismiss(after: 1.5)
        }
        
        Button("State-based (toggle)") {
          isPresented.toggle()
        }
      }
    }
    .notification(isPresented: $isPresented, style: {
      let s = $0.backgroundStyle
      s.backgroundColor = .black
      s.pillStyle.minimumWidth = 150
      s.pillStyle.height = 44
    }) {
      Text("👋 Hi there!")
        .font(.subheadline)
        .foregroundStyle(.white)
    }
    
  }
}

struct HelloSPMView: View {

  @State var title: String

  var body: some View {
    HStack(spacing: 0) {
      Image(systemName: "hands.sparkles.fill")
        .foregroundStyle(.teal)
        .padding(.trailing, 10)

      Text(title)
        .font(.caption)
        .foregroundStyle(.white)
    }
    .padding(.horizontal, 20)
  }
}

#Preview {
  ContentView1()
}
