//
//

import SwiftUI

@available(iOS 15.0, *)
enum OptionalColorViewFactory {
  static func buildPicker(title: String, binding: Binding<UIColor?>) -> some View {
    ColorPicker(title, selection: Binding<CGColor>(get: {
      binding.wrappedValue?.cgColor ?? UIColor.white.cgColor
    }, set: { val in
      binding.wrappedValue = UIColor(cgColor: val)
    }))
    .font(.subheadline)
  }

  static func buildToggle(title: String, binding: Binding<UIColor?>, defaultColor: UIColor?) -> some View {
    Toggle(title, isOn: Binding(get: {
      binding.wrappedValue != nil
    }, set: { on in
      binding.wrappedValue = on ? defaultColor : nil
    }))
    .font(.subheadline)
  }
}

enum CGSizeStepperFactory {
  static func build(title: String, binding: Binding<CGSize>) -> some View {
    VStack(alignment: .leading, spacing: 6.0) {
      Text("\(title) (\(Int(binding.width.wrappedValue))/\(Int(binding.height.wrappedValue)))")
        .font(.subheadline)
      HStack(alignment: .center, spacing: 20.0) {
        Spacer()
        Stepper("X:", value: binding.width)
          .frame(width: 120)
          .font(.subheadline)
        Stepper("Y:", value: binding.height)
          .frame(width: 120)
          .font(.subheadline)
        Spacer()
      }
    }
  }
}

struct PickerFactory<T, SomeView> where T: Hashable, SomeView: View {
  static func build(title: String,
                    binding: Binding<T>,
                    @ViewBuilder content: () -> SomeView) -> some View
  {
    VStack(alignment: .leading, spacing: 6.0) {
      Text(title)
        .font(.subheadline)
        .padding(.top, 4.0)
      Picker("", selection: binding) {
        content()
      }.pickerStyle(.segmented)
    }
  }
}

@available(iOS 15.0, *)
struct TextFieldStepper: View {
  var title: String
  var binding: Binding<Double>
  var range: ClosedRange<Double> = -999 ... 999

  @FocusState private var isFocused: Bool

  var body: some View {
    HStack {
      Stepper(title, value: binding, in: range, onEditingChanged: { val in
        isFocused = false
      })
      .font(.subheadline)
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
      OptionalColorViewFactory.buildPicker(title: "Color picker", binding: .constant(.red))
      OptionalColorViewFactory.buildToggle(title: "Color resetting toggle", binding: .constant(nil), defaultColor: .blue)

      CGSizeStepperFactory.build(title: "CGSize Control", binding: .constant(CGSize(width: 20, height: 20)))

      PickerFactory.build(title: "Inline Picker", binding: .constant(1)) {
        Text("one").tag(1)
        Text("two").tag(2)
        Text("three").tag(3)
      }

      TextFieldStepper(title: "Stepper + Textfield", binding: .constant(23))
    }
  }
}
