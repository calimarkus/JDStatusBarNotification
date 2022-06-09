//
//

import SwiftUI

protocol StringRepresentable {
  var stringValue: String { get }
}

extension IncludedStatusBarStyle: StringRepresentable {
  var stringValue: String {
    switch self {
      case .default: return ".default"
      case .light: return ".light"
      case .dark: return ".dark"
      case .success: return ".success"
      case .warning: return ".warning"
      case .error: return ".error"
      case .matrix: return ".matrix"
      default: return "?"
    }
  }
}

extension BarAnimationType: StringRepresentable {
  var stringValue: String {
    switch self {
      case .move: return ".move"
      case .fade: return ".fade"
      case .bounce: return ".bounce"
      default: return "?"
    }
  }
}

extension BarBackgroundType: StringRepresentable {
  var stringValue: String {
    switch self {
      case .fullWidth: return ".fullWidth"
      case .pill: return ".pill"
      default: return "?"
    }
  }
}

extension StatusBarSystemStyle: StringRepresentable {
  var stringValue: String {
    switch self {
      case .default: return ".default"
      case .lightContent: return ".lightContent"
      case .darkContent: return ".darkContent"
      default: return "?"
    }
  }
}

extension ProgressBarPosition: StringRepresentable {
  var stringValue: String {
    switch self {
      case .top: return ".top"
      case .center: return ".center"
      case .bottom: return ".bottom"
      default: return "?"
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

@available(iOS 15.0, *)
struct EnumPickerOptionView_Previews: PreviewProvider {
  static var previews: some View {
    Form {
      Picker("Test", selection: .constant(IncludedStatusBarStyle.light)) {
        EnumPickerOptionView(IncludedStatusBarStyle.light)
        EnumPickerOptionView(IncludedStatusBarStyle.dark)
      }
      .pickerStyle(.inline)
    }
  }
}
