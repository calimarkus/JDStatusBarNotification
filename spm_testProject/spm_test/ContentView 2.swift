//
//

import JDStatusBarNotification
import SwiftUI

struct ContentView2: View {

  @State var isPresented: Bool = false
  @State var activity: Bool = false
  @State var progress: Double = 0.0

  var body: some View {
    List {
      Section {
        Button("Present/dismiss") {
          isPresented.toggle()
        }
      }

      Section {
        Button("Activity on/off") {
          isPresented = true
          activity.toggle()
        }

        Button("Shuffle progress") {
          isPresented = true
          progress = Double(arc4random() % 1000) / 1000.0
        }

        Button("Reset") {
          activity = false
          progress = 0
        }
      }
    }
    .notification(title: "Simple text",
                  subtitle: "with a little subtitle.",
                  isPresented: $isPresented,
                  isShowingActivity: $activity,
                  progress: $progress,
                  includedStyle: .success)
  }
}

#Preview {
  ContentView2()
}
