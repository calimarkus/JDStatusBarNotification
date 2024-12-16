# Getting Started

All examples here are written in Swift. But everything can be called from Objective-C too. Also checkout the example project, which has many examples and includes a convenient style editor to build a custom style.

Explore the full API in ``JDStatusBarNotification/NotificationPresenter``.

## SwiftUI state-driven presentation

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

## Manual presentation (from Swift or ObjC)

### Showing a text notification

See ``NotificationPresenter/present(_:subtitle:styleName:duration:completion:)``

```swift
NotificationPresenter.shared.present("Hello World")

// with completion
NotificationPresenter.shared.present("Hello World") { presenter in
   // ...
}
```

### Dismissing a notification

See ``NotificationPresenter/dismiss(animated:after:completion:)``

```swift
NotificationPresenter.shared.dismiss()

// with completion
NotificationPresenter.shared.dismiss(after: 0.5) { presenter in
   // ...
}
```

### Showing activity

See ``NotificationPresenter/displayActivityIndicator(_:)``

```swift
NotificationPresenter.shared.present("")
NotificationPresenter.shared.displayActivityIndicator(true)
```

![activity](https://user-images.githubusercontent.com/807039/175884729-c6255d41-4728-4bcb-bf72-fb12db01b5d5.gif)
    
### Showing a custom left view

See ``NotificationPresenter/displayLeftView(_:)``

```swift
let image = UIImageView(image: UIImage(systemName: "gamecontroller.fill"))
NotificationPresenter.shared.present("Player II", subtitle: "Connected")
NotificationPresenter.shared.displayLeftView(image)
```

![leftview](https://user-images.githubusercontent.com/807039/175884751-c93ffd31-a436-43d2-9eed-82d7cb23d8f6.gif)

### Showing progress

See ``NotificationPresenter/animateProgressBar(to:duration:completion:)``

```swift
NotificationPresenter.shared.present("Animating Progress…") { presenter in
  presenter.animateProgressBar(to: 1.0, duration: 0.75) { presenter in
    presenter.dismiss()
  }
}

// or set an explicit percentage manually (without animation)
NotificationPresenter.shared.displayProgressBar(at: 0.0)
```

![progress](https://user-images.githubusercontent.com/807039/175886588-e1aba466-85fa-4e32-951a-cd368c7d553d.gif)

### Using other included styles

There's a few included styles you can easily use with the following API:

See ``NotificationPresenter/present(_:subtitle:includedStyle:duration:completion:)``

```swift
NotificationPresenter.shared.present("Yay, it works!",
                                     includedStyle: .success)
```

![itworks](https://user-images.githubusercontent.com/807039/175888059-3beeb659-b561-4e7c-9c66-6fbc683ae152.jpg)

### Showing a custom SwiftUI view (Swift only)

See ``NotificationPresenter/presentSwiftView(styleName:viewBuilder:completion:)``

```swift
NotificationPresenter.shared.presentSwiftView {
    Text("Hi from Swift!")
}

// with completion
NotificationPresenter.shared.presentSwiftView {
    Text("Hi from Swift!")
} completion: { presenter in
   // ...
}
```

### Using a custom UIView (Swift or ObjC)

If you want full control over the notification content and styling, you can use your own custom UIView.

See ``NotificationPresenter/presentCustomView(_:sizingController:styleName:completion:)``

```swift
// present a custom view
let button = UIButton(type: .system, primaryAction: UIAction { _ in
  NotificationPresenter.shared.dismiss()
})
button.setTitle("Dismiss!", for: .normal)
NotificationPresenter.shared.presentCustomView(button)
```

| Light Mode  | Dark Mode |
| --- | --- |
| ![customView](https://user-images.githubusercontent.com/807039/173234544-7a75edbe-00b1-437b-8651-2e63a1ba63c8.gif) | ![customView2](https://user-images.githubusercontent.com/807039/173234636-b3745101-0723-4342-9a3a-32a868ea820e.gif) |

## Customization

You have the option to easily create & use fully customized styles.

### From SwiftUI

Modify the style in a `NotificationStyleClosure`:

```swift
var body: some View {
    Button("Present/dismiss") {
      isPresented.toggle()
    }
    .notification(isPresented: $isPresented, style: {
      let s = $0.backgroundStyle
      s.backgroundColor = .black
      s.pillStyle.minimumWidth = 150
      s.pillStyle.height = 44
    }) {
      Text("👋 Hi there!")
        .font(.subheadline)
        .foregroundStyle(.white)
    }
}
```

### Manually

See ``NotificationPresenter/updateDefaultStyle(_:)`` and ``NotificationPresenter/addStyle(named:usingStyle:prepare:)``

The ``NotificationPresenter/PrepareStyleClosure`` provides a copy of the default style, which can then be modified. See the ``JDStatusBarNotification/StatusBarNotificationStyle`` API for all options.

```swift
// update default style
NotificationPresenter.shared.updateDefaultStyle { style in
   style.backgroundStyle.backgroundColor = .red
   style.textStyle.textColor = .white
   style.textStyle.font = UIFont.preferredFont(forTextStyle: .title3)
   // and many more options
   return style
}

// set a named custom style
NotificationPresenter.shared.addStyle(named: "xxx") { style in
   // ...
   return style
}
```
