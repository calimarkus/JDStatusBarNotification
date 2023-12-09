//
//

import SwiftUI
import JDStatusBarNotification

protocol StringRepresentable {
  var stringValue: String { get }
}

extension IncludedStatusBarNotificationStyle: StringRepresentable {
  var stringValue: String {
    switch self {
      case .defaultStyle: return ".defaultStyle"
      case .light: return ".light"
      case .dark: return ".dark"
      case .success: return ".success"
      case .warning: return ".warning"
      case .error: return ".error"
      case .matrix: return ".matrix"
    }
  }
}

extension StatusBarNotificationAnimationType: StringRepresentable {
  var stringValue: String {
    switch self {
      case .move: return ".move"
      case .fade: return ".fade"
      case .bounce: return ".bounce"
    }
  }
}

extension StatusBarNotificationBackgroundType: StringRepresentable {
  var stringValue: String {
    switch self {
      case .fullWidth: return ".fullWidth"
      case .pill: return ".pill"
    }
  }
}

extension StatusBarNotificationSystemBarStyle: StringRepresentable {
  var stringValue: String {
    switch self {
      case .defaultStyle: return ".defaultStyle"
      case .lightContent: return ".lightContent"
      case .darkContent: return ".darkContent"
    }
  }
}

extension StatusBarNotificationLeftViewAlignment: StringRepresentable {
  var stringValue: String {
    switch self {
      case .left: return ".left"
      case .centerWithText: return ".centerWithText"
    }
  }
}

extension StatusBarNotificationProgressBarPosition: StringRepresentable {
  var stringValue: String {
    switch self {
      case .top: return ".top"
      case .center: return ".center"
      case .bottom: return ".bottom"
    }
  }
}

struct EnumPickerOptionView<T: StringRepresentable>: View where T: Hashable {
  var representable: T

  init(_ representable: T) {
    self.representable = representable
  }

  var body: some View {
    Text(representable.stringValue).tag(representable)
  }
}

struct EnumPickerOptionView_Previews: PreviewProvider {
  static var previews: some View {
    Form {
      SegmentedPicker(title: "Test", value: .constant(IncludedStatusBarNotificationStyle.dark)) {
        EnumPickerOptionView(IncludedStatusBarNotificationStyle.light)
        EnumPickerOptionView(IncludedStatusBarNotificationStyle.dark)
      }
    }
  }
}
