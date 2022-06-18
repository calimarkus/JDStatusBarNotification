//
//

import SwiftUI

@available(iOS 15.0, *)
struct TextStyleForm: View {
  @ObservedObject var style: CustomTextStyle
  let defaultShadowColor: UIColor?
  let onChange: () -> Void

  var body: some View {
    EmptyView()
      .onChange(of: style) { _ in
        onChange()
      }

    NavigationLink(destination: {
      FontPicker(font: $style.font)
    }, label: {
      HStack {
        Text("Font").font(.subheadline)
        Spacer()
        Text("\(style.font.fontDescriptor.postscriptName)")
          .font(.caption)
      }
    })

    TextFieldStepper(title: "Font size", binding: Binding<Double>(get: {
      style.font.pointSize
    }, set: { size in
      style.font = style.font.withSize(size)
    }), range: 5 ... 36)

    TextFieldStepper(title: "Text Offset Y", binding: $style.textOffsetY, range: -30 ... 30)
    OptionalColorPicker(title: "Text Color", color: $style.textColor)
    OptionalColorToggle(title: "Text Shadow", color: $style.textShadowColor, defaultColor: defaultShadowColor)

    if let _ = style.textShadowColor {
      OptionalColorPicker(title: "  Shadow Color", color: $style.textShadowColor)
        .font(.caption)
      CGSizeStepper(title: "  Shadow Offset", size: $style.textShadowOffset)
    }
  }
}

@available(iOS 15.0, *)
struct TextStyleForm_Previews: PreviewProvider {
  static var previews: some View {
    Form {
      TextStyleForm(
        style: CustomTextStyle(StatusBarStyle().textStyle),
        defaultShadowColor: nil
      ) {}
    }
  }
}
