//
//

import SwiftUI

@available(iOS 15.0, *)
struct TextStyleEditorView: View {
  let title: String
  @ObservedObject var style: CustomTextStyle
  let defaultShadowColor: UIColor?
  let onChange: () -> Void

  var body: some View {
    EmptyView()
      .onChange(of: style) { _ in
        onChange()
      }

    NavigationLink(
      destination: {
        FontPickerView(font: $style.font)
          .navigationTitle("\(title) Font")
      },
      label: {
        HStack {
          Text("Font").font(.subheadline)
          Spacer()
          Text("\(style.font.fontDescriptor.postscriptName)")
            .font(.caption)
        }
      }
    )

    TextFieldStepper(title: "Font size", binding: Binding<Double>(get: {
      style.font.pointSize
    }, set: { size in
      style.font = style.font.withSize(size)
    }), range: 5 ... 36)

    TextFieldStepper(title: "Offset Y", binding: $style.textOffsetY, range: -30 ... 30)
    OptionalColorPicker(title: "Color", color: $style.textColor)
    OptionalColorToggle(title: "Shadow", color: $style.shadowColor, defaultColor: defaultShadowColor)

    if let _ = style.shadowColor {
      OptionalColorPicker(title: "  Shadow Color", color: $style.shadowColor)
        .font(.caption)
      CGPointStepper(title: "  Shadow Offset", point: $style.shadowOffset)
    }
  }
}

@available(iOS 15.0, *)
struct TextStyleEditorView_Previews: PreviewProvider {
  static var previews: some View {
    Form {
      TextStyleEditorView(
        title: "Title",
        style: CustomTextStyle(StatusBarStyle().textStyle),
        defaultShadowColor: nil
      ) {}
    }
  }
}
