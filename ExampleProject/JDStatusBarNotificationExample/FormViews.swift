//
//

import SwiftUI

@available(iOS 14.0, *)
struct InfoLabel: View {
  let text: String

  var body: some View {
    HStack {
      Spacer(minLength: 0.0)
      Text(text)
        .font(.caption2)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
      Spacer(minLength: 0.0)
    }.disabled(true)
  }
}

@available(iOS 15.0, *)
struct OptionalColorPicker: View {
  var title: String
  @Binding var color: UIColor?

  var body: some View {
    ColorPicker(title, selection: Binding<CGColor>(get: {
      color?.cgColor ?? UIColor.white.cgColor
    }, set: { val in
      color = UIColor(cgColor: val)
    }))
    .font(.subheadline)
  }
}

@available(iOS 14.0, *)
struct OptionalColorToggle<SomeView>: View where SomeView: View {
  var title: String
  @Binding var color: UIColor?
  var defaultColor: UIColor?
  @ViewBuilder var content: SomeView

  var body: some View {
    DisclosureGroup(title, isExpanded: Binding(get: {
      color != nil
    }, set: { on in
      color = on ? defaultColor : nil
    })) {
      content
    }
    .font(.subheadline)
    .accentColor(.secondary)
  }
}

@available(iOS 15.0, *)
struct CGPointStepper: View {
  var title: String
  @Binding var point: CGPoint

  var body: some View {
    HStack(alignment: .center, spacing: 6.0) {
      Text(title)
        .font(.subheadline)
      Spacer()
      VStack(alignment: .trailing, spacing: 7.0) {
        TextFieldStepper(title: "X:", binding: $point.x.native, fixedSizeStepper: true)
        TextFieldStepper(title: "Y:", binding: $point.y.native, fixedSizeStepper: true)
      }
    }
  }
}

struct SegmentedPicker<T, SomeView>: View where T: Hashable, SomeView: View {
  var title: String
  @Binding var value: T
  @ViewBuilder var content: SomeView

  var body: some View {
    VStack(alignment: .leading, spacing: 6.0) {
      if title.count > 0 {
        Text(title)
          .font(.subheadline)
          .padding(.top, 4.0)
      }
      Picker("", selection: $value) {
        content
      }.pickerStyle(.segmented)
    }
  }
}

@available(iOS 15.0, *)
struct TextFieldStepper: View {
  var title: String
  var binding: Binding<Double>
  var range: ClosedRange<Double> = -999 ... 999
  var fixedSizeStepper: Bool = false

  @FocusState private var isFocused: Bool

  var body: some View {
    HStack {
      Stepper(title, value: binding, in: range, onEditingChanged: { _ in
        isFocused = false
      })
      .font(.subheadline)
      .lineLimit(2)
      .minimumScaleFactor(0.8)
      .fixedSize(horizontal: fixedSizeStepper, vertical: fixedSizeStepper)

      TextField(value: binding, format: .number) {
        EmptyView()
      }
      .frame(width: 50)
      .textFieldStyle(.roundedBorder)
      .font(.subheadline)
      .focused($isFocused)
      .onChange(of: binding.wrappedValue, perform: { newValue in
        binding.wrappedValue = min(range.upperBound, max(range.lowerBound, newValue))
      })
    }
  }
}

@available(iOS 15.0, *)
struct FormFactory_Previews: PreviewProvider {
  static var previews: some View {
    Form {
      OptionalColorPicker(title: "Color picker", color: .constant(.red))
      OptionalColorToggle(title: "Color resetting toggle", color: .constant(nil), defaultColor: .blue) {
        Text("I am")
        Text("hidden")
      }

      TextFieldStepper(title: "Stepper + Textfield I", binding: .constant(1))
      TextFieldStepper(title: "Stepper + Textfield II with some additional text", binding: .constant(23))

      CGPointStepper(title: "CGPoint", point: .constant(CGPoint(x: 20, y: 20)))

      SegmentedPicker(title: "Inline Picker", value: .constant(1)) {
        Text("one").tag(1)
        Text("two").tag(2)
        Text("three").tag(3)
      }

      InfoLabel(text: "But let me tell ya, these settings need careful consideration. So better be careful!")
    }
  }
}
