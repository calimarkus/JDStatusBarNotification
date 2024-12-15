# JDStatusBarNotification

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fcalimarkus%2FJDStatusBarNotification%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/calimarkus/JDStatusBarNotification)

Highly customizable & feature rich notifications displayed below the status bar / notch / Island. Written in Swift, compatible for Obj-C! Please open a [Github issue](https://github.com/calimarkus/JDStatusBarNotification/issues), if you think anything is missing or wrong.

* Customizable colors, fonts & animations with multiple built-in styles
* Interactive & interuptable Drag-to-Dismiss
* Adaptive, dynamic layout
    * Built-in pill-style or full-width layouts
    * Pill width matches the presented text (customizable)
    * Works on notch and no-notch devices
    * Works in landscape & portrait
* Built-in features (automatic layout):
    * Title, subtitle and left-hand-views (e.g. Icons)
    * An activity indicator
    * A progress bar
    * Custom views (UIView or SwiftUI View)

Some examples of the possibilities - the pill style is the default:

![examples](https://user-images.githubusercontent.com/807039/173831886-d7c8cca9-9274-429d-b924-78f21a4f6092.jpg)

Full-Width styles in action - the above pill style supports the same features and animations:

| Drag to dismiss | Activity & Progress Bars | Custom styles |
| ------------- | ------------- | ------------- |
| ![1](https://user-images.githubusercontent.com/807039/172001713-74d8c212-cd58-4687-8d6b-472e1bdb944d.gif) | ![3](https://user-images.githubusercontent.com/807039/172001734-be3c4e36-46b6-4f9f-a3d5-59a51e5db675.gif) | ![2](https://user-images.githubusercontent.com/807039/172001727-65aa6374-beeb-4a5c-adac-7e1967236b63.gif) |

| Landscape apps (device rotation also supported) |
| ------------- |
| ![landscape](https://user-images.githubusercontent.com/807039/172003389-7752a183-f960-4bef-87c7-fcf583e4a13f.gif) |

## Installation

- [**SPM (Swift Package Manager):**](https://github.com/apple/swift-package-manager)
  - Xcode -> File -> Add packages: `git@github.com:calimarkus/JDStatusBarNotification.git`
  - Importing:
      - In Swift: `import JDStatusBarNotification`
      - In ObjC: `@import JDStatusBarNotification;`
- [**CocoaPods:**](https://guides.cocoapods.org)
  - `pod 'JDStatusBarNotification'`
- [**Carthage:**](https://github.com/Carthage/Carthage)
  - `github "calimarkus/JDStatusBarNotification"`
- **Manually:**
  - Copy the `JDStatusBarNotification/JDStatusBarNotification` folder into your project.

## Documentation

Find the [class documentation](http://calimarkus.github.io/JDStatusBarNotification/documentation/jdstatusbarnotification) hosted on Github.

## Changelog

See [CHANGELOG.md](CHANGELOG.md)

## Getting started

All examples here are written in Swift. But everything can be called from Objective-C too. Also checkout the example project, which has many examples and includes a convenient style editor to build a custom style.

### SwiftUI state-driven presentation

#### Showing a simple text notification

```swift
var body: some View {
    Button("Present/dismiss") {
      isPresented.toggle()
    }
    .notification(title: "Hello World", isPresented: $isPresented)
}
```

#### Showing a styled notification with subtitle, activity and/or progress

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


#### Showing a custom view as notification

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

### Manual presentation (from Swift or ObjC)

#### Showing a text notification

```swift
NotificationPresenter.shared.present("Hello World")

// with completion
NotificationPresenter.shared.present("Hello World") { presenter in
    // ...
}
```

#### Dismissing a notification

```swift
NotificationPresenter.shared.dismiss()

// with completion
NotificationPresenter.shared.dismiss(after: 0.5) { presenter in
   // ...
}
```

#### Showing activity

```swift
NotificationPresenter.shared.present("")
NotificationPresenter.shared.displayActivityIndicator(true)
```

![activity](https://user-images.githubusercontent.com/807039/175884729-c6255d41-4728-4bcb-bf72-fb12db01b5d5.gif)

#### Showing a custom left view

```swift
let image = UIImageView(image: UIImage(systemName: "gamecontroller.fill"))
NotificationPresenter.shared.present("Player II", subtitle: "Connected")
NotificationPresenter.shared.displayLeftView(image)
```

![leftview](https://user-images.githubusercontent.com/807039/175884751-c93ffd31-a436-43d2-9eed-82d7cb23d8f6.gif)

#### Showing progress

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

#### Using other included styles

There's a few included styles you can easily use with the following API:

```swift
NotificationPresenter.shared.present("Yay, it works!",
                                     includedStyle: .success)
```

![itworks](https://user-images.githubusercontent.com/807039/175888059-3beeb659-b561-4e7c-9c66-6fbc683ae152.jpg)

#### Showing a custom SwiftUI view (Swift only)

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

#### Using a custom UIView (Swift or ObjC)

If you want full control over the notification content and styling, you can use your own custom UIView.

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

The ``PrepareStyleClosure`` provides a copy of the default style, which can then be modified. See the ``StatusBarNotificationStyle`` API for all options.

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

### Style Editor

Or checkout the example project, which contains a full style editor. You can tweak all customization options within the app, see the changes live and even export the configuration code for the newly created style to easily use it in your app.

![style-editor](https://user-images.githubusercontent.com/807039/174438815-4e3de17f-eb15-4281-b786-c1bfce7415da.jpg)

### Background Styles

There's two supported `StatusBarNotificationBackgroundType`'s:

```swift
enum {
    /// The background is a floating pill around the text.
    /// The pill size and appearance can be customized. This is the default.
    .pill,

    /// The background covers the full display width and the full status bar + navbar height.
    .fullWidth
}
```

### Animation Types

The supported `StatusBarNotificationAnimationType`'s:

```swift
enum {
    /// Slide in from the top of the screen and slide
    /// back out to the top. This is the default.
    .move,

    /// Fade-in and fade-out in place. No movement animation.
    .fade,

    /// Fall down from the top and bounce a little bit, before
    /// coming to a rest. Slides back out to the top.
    .bounce
}
```

## Troubleshooting

### No notifications are showing up

If your app uses a `UIWindowScene` the `NotificationPresenter` needs to know about it before you present any notifications.
The library attempts to find the correct WindowScene automatically, but that might fail. If it fails no notifications will show up at all. You can explicitly set the window scene to resolve this:

```swift
NotificationPresenter.shared().setWindowScene(windowScene)
```

## Twitter

I'm [@calimarkus](http://twitter.com/calimarkus) on Twitter. Feel free to [post a tweet](https://twitter.com/intent/tweet?button_hashtag=JDStatusBarNotification&text=Simple%20and%20customizable%20statusbar%20notifications%20for%20iOS!%20Check%20it%20out.%20https://github.com/calimarkus/JDStatusBarNotification&via=calimarkus), if you like JDStatusBarNotification.  

[![tweetbutton](https://user-images.githubusercontent.com/807039/170856086-2c283e68-a44f-4a9f-b327-bd5a7c654455.png)](https://twitter.com/intent/tweet?button_hashtag=JDStatusBarNotification&text=Simple%20and%20customizable%20statusbar%20notifications%20for%20iOS!%20Check%20it%20out.%20https://github.com/calimarkus/JDStatusBarNotification&via=calimarkus)

## Credits

Originally based on `KGStatusBar` by Kevin Gibbon
