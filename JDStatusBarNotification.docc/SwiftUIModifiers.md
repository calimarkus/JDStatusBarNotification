# SwiftUI modifiers

These modifiers let you easily present state-driven notifications from within your SwiftUI views. Just like alerts or sheets!

## Examples

### Showing a simple text notification

```swift
var body: some View {
    Button("Present/dismiss") {
      isPresented.toggle()
    }
    .notification(title: "Hello World", isPresented: $isPresented)
}
```

### Showing a styled notification with subtitle, activity and/or progress

```swift
var body: some View {
    Button("Present/dismiss") {
      isPresented.toggle()
    }
    .notification(title: "A text",
                  subtitle: "with a little subtitle.",
                  isPresented: $isPresented,
                  isShowingActivity: $activity, // toggles an activity indicator on/off
                  progress: $progress,          // sets the percentage of a progress bar
                  includedStyle: .success)      // picks a predefined style
}
```


### Showing a custom view as notification

```swift
var body: some View {
    Button("Present/dismiss") {
      isPresented.toggle()
    }
    .notification(isPresented: $isPresented) {
      Text("👋 Hi there!")
        .font(.subheadline)
        .foregroundStyle(.white)
    }
}
```

Explore all SwiftUI `View` extensions in ``SwiftUICore/View/``.

## Using a ViewBuilder

- ``SwiftUICore/View/notification(isPresented:style:viewBuilder:)``
- ``SwiftUICore/View/notification(isPresented:styleName:viewBuilder:)``
- ``SwiftUICore/View/notification(isPresented:includedStyle:viewBuilder:)``

## Using a title/subtitle

- ``SwiftUICore/View/notification(title:subtitle:isPresented:isShowingActivity:progress:style:)``
- ``SwiftUICore/View/notification(title:subtitle:isPresented:isShowingActivity:progress:styleName:)``
- ``SwiftUICore/View/notification(title:subtitle:isPresented:isShowingActivity:progress:includedStyle:)``

## Style closure

The style closure lets you conveniently modify the style of the presented notification inline.

- ``SwiftUICore/View/NotificationStyleClosure``
