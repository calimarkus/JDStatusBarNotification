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

    Stepper("Font size (\(Int(style.font.pointSize)) pt)", value:
      Binding<CGFloat>(get: {
        style.font.pointSize
      }, set: { size in
        style.font = style.font.withSize(size)
      }), in: 5 ... 36)
      .font(.subheadline)

    Stepper("Text Offset Y (\(Int(style.textOffsetY)))",
            value: $style.textOffsetY)
      .font(.subheadline)

    OptionalColorViewFactory.buildPicker(title: "Text Color", binding: $style.textColor)

    OptionalColorViewFactory.buildToggle(title: "Text Shadow", binding: $style.textShadowColor, defaultColor: defaultShadowColor)

    if let _ = style.textShadowColor {
      OptionalColorViewFactory.buildPicker(title: "  Shadow Color", binding: $style.textShadowColor)
        .font(.caption)

      CGSizeStepperFactory.build(title: "  Shadow Offset", binding: $style.textShadowOffset)
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
