//
//

import SwiftUI

@main
struct spm_testApp: App {
  var body: some Scene {
    WindowGroup {
      TabView {
        Tab("Example 1", systemImage: "house") {
          NavigationView {
            ContentView1()
              .navigationTitle("SPM Example #1")
          }
        }
        Tab("Example 2", systemImage: "house") {
          NavigationView {
            ContentView2()
              .navigationTitle("SPM Example #2")
          }
        }
      }
    }
  }
}
