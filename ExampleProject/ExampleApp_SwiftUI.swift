//
//

import SwiftUI
import JDStatusBarNotification

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
          NavigationView {
            ExamplesScreen(title: "ExampleApp (SwiftUI)")
          }
          .onAppear {
            let text = "👋 Hello World!"
            NotificationPresenter.shared.present(text, includedStyle: .matrix, duration: 2.5)
          }
        }
    }
}
