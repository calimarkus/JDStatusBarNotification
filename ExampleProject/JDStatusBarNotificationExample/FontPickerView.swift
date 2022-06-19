//
//

import SwiftUI

@available(iOS 15.0, *)
public struct FontPickerView: UIViewControllerRepresentable {
  @Environment(\.presentationMode) var presentationMode
  @Binding var font: UIFont

  public init(font: Binding<UIFont>) {
    self._font = font
  }

  public func makeUIViewController(context: UIViewControllerRepresentableContext<FontPickerView>) -> UIFontPickerViewController {
    let configuration = UIFontPickerViewController.Configuration()
    configuration.includeFaces = true
    let vc = UIFontPickerViewController(configuration: configuration)
    vc.delegate = context.coordinator
    vc.selectedFontDescriptor = context.coordinator.font.fontDescriptor
    return vc
  }

  public func makeCoordinator() -> FontPickerView.Coordinator {
    return Coordinator(self, font: $font)
  }

  public class Coordinator: NSObject, UIFontPickerViewControllerDelegate {
    var parent: FontPickerView
    @Binding var font: UIFont

    init(_ parent: FontPickerView, font: Binding<UIFont>) {
      self.parent = parent
      self._font = font
    }

    public func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
      guard let descriptor = viewController.selectedFontDescriptor else { return }
      $font.wrappedValue = UIFont(descriptor: descriptor, size: font.pointSize)
      parent.presentationMode.wrappedValue.dismiss()
    }

    public func fontPickerViewControllerDidCancel(_ viewController: UIFontPickerViewController) {
      parent.presentationMode.wrappedValue.dismiss()
    }
  }

  public func updateUIViewController(_ uiViewController: UIFontPickerViewController,
                                     context: UIViewControllerRepresentableContext<FontPickerView>) {}
}
