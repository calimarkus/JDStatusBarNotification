# JDStatusBarNotification

Highly customizable & feature rich notifications displayed below the status bar for both notch and no-notch devices.
Customizable colors, fonts & animations. Drag to dismiss. Landscape / portrait. Can show an activity indicator,
a progress bar & custom views. iOS 13+. Swift ready!

Please open a [Github issue](https://github.com/calimarkus/JDStatusBarNotification/issues), if you think anything is missing or wrong.

Here's some examples of the possibilities (the pill style is the default):

![examples](https://user-images.githubusercontent.com/807039/173831886-d7c8cca9-9274-429d-b924-78f21a4f6092.jpg)

Full-Width styles in action (the pill styles support the same features / animations):

| Drag to dismiss | Activity & Progress Bars | Custom styles |
| ------------- | ------------- | ------------- |
| ![1](https://user-images.githubusercontent.com/807039/172001713-74d8c212-cd58-4687-8d6b-472e1bdb944d.gif) | ![3](https://user-images.githubusercontent.com/807039/172001734-be3c4e36-46b6-4f9f-a3d5-59a51e5db675.gif) | ![2](https://user-images.githubusercontent.com/807039/172001727-65aa6374-beeb-4a5c-adac-7e1967236b63.gif) |

| Landscape apps (device rotation also supported) |
| ------------- |
| ![landscape](https://user-images.githubusercontent.com/807039/172003389-7752a183-f960-4bef-87c7-fcf583e4a13f.gif) |

## Installation

- [**SwiftPM:**](https://github.com/apple/swift-package-manager)
  - Xcode -> File -> Add packages: `git@github.com:calimarkus/JDStatusBarNotification.git`
- [**CocoaPods:**](https://guides.cocoapods.org)
  - `pod 'JDStatusBarNotification'`
- [**Carthage:**](https://github.com/Carthage/Carthage)
  - `github "calimarkus/JDStatusBarNotification"`
- **Manually:**
  - Copy the `JDStatusBarNotification/JDStatusBarNotification` folder into your project.

## Usage

`NotificationPresenter` is a singleton. You don't need to initialize it anywhere.
All examples are Swift code, but the class can be used in Objective-C as well.
Also checkout the example project, which has many examples and includes a convenient style editor.

Here's some usage examples:

### Showing a text notification

It's as simple as this:

```swift
NotificationPresenter.shared().present(text: "Hello World")

// with completion
NotificationPresenter.shared().present(text: "Hello World") { presenter in
   // ...
}
```

### Dismissing a notification

```swift
NotificationPresenter.shared().dismiss(animated: true)

// with completion
NotificationPresenter.shared().dismiss(afterDelay: 0.5) { presenter in
   // ...
}
```
    
### Showing progress

![progress](https://user-images.githubusercontent.com/807039/173359598-bcd5c6c9-939d-4660-972e-a230cb1efcfe.gif)

```swift
NotificationPresenter.shared().displayProgressBar(percentage: 0.5)

// or animated
NotificationPresenter.shared().animateProgressBar(toPercentage: 1.0, animationDuration: 1.0) { presenter in
   // ...
}
```
    
### Showing activity

![activity](https://user-images.githubusercontent.com/807039/173359085-a6ab34b3-13ca-469b-8df2-669f273929cc.gif)

```swift
NotificationPresenter.shared().displayActivityIndicator(true)
```
    
### Using alternative styles

There's a few included styles you can easily use with the following API:

```swift
NotificationPresenter.shared().present(text: "Yay, it works!", includedStyle: .success)
```

## Troubleshooting

### No notifications are showing up

If your app uses a `UIWindowScene` the `NotificationPresenter` needs to know about it before you present any notifications.
The library attempts to find the correct WindowScene automatically, but that might fail. If it fails no notifications will show up at all. You can explicitly set the window scene to resolve this:

```swift
NotificationPresenter.shared().setWindowScene(windowScene)
```

## Customization

You have the option to create fully customized styles - or to even present custom views.

The closures of `updateDefaultStyle()` and `addStyle(styleName: String)` provide a copy of the default style, which can then be modified. See the `JDStatusBarStyle` class (or the style editor in the example project) for all options and documentation. You can also use the example project's style editor to create a style visually and then export the code to configure that style.

```swift
// update default style
NotificationPresenter.shared().updateDefaultStyle { style in
   style.backgroundStyle.backgroundColor = .red
   style.textStyle.textColor = .white
   style.textStyle.font = UIFont.preferredFont(forTextStyle: .title3)
   // and many more options
   return style
}

// set a named custom style
NotificationPresenter.shared().addStyle(styleName: "xxx") { style in
   // ...
   return style
}
```

#### Style Editor

Checkout the example project, which contains a full style editor. You can tweak all customization options within the app, see the changes live and even export the configuration code.

![styleditor](https://user-images.githubusercontent.com/807039/173832850-296a0f49-244c-415d-af1c-f1c5f6f32e9f.jpg)

#### Custom View

![customView](https://user-images.githubusercontent.com/807039/173234544-7a75edbe-00b1-437b-8651-2e63a1ba63c8.gif)  ![customView2](https://user-images.githubusercontent.com/807039/173234636-b3745101-0723-4342-9a3a-32a868ea820e.gif)

```swift
// present a custom view
var anyView: UIView = ...
NotificationPresenter.shared().present(customView: anyView)
```

#### Background Styles

There's two supported background styles:

```objc
typedef NS_ENUM(NSInteger, JDStatusBarBackgroundType) {
  /// The background covers the full display width and the full status bar & navbar height.
  JDStatusBarBackgroundTypeFullWidth,
  /// The background is a floating pill around the text.
  JDStatusBarBackgroundTypePill,
} NS_SWIFT_NAME(BarBackgroundType);
```

#### Animation Types

The supported animation types:

```objc
typedef NS_ENUM(NSInteger, JDStatusBarAnimationType) {
  /// Notification will move in from the top, and move out again to the top
  JDStatusBarAnimationTypeMove,
  /// Notification will fall down from the top and bounce a little bit
  JDStatusBarAnimationTypeBounce,
  /// Notification will fade in and fade out
  JDStatusBarAnimationTypeFade,
} NS_SWIFT_NAME(BarAnimationType);
```

## Changelog

### 2.0.1

New:

- Subtitle support (customizable)
- Generic left view support (think icons, profile pictures, etc.), customizable layout

Fixes:

- WindowScene inferred automatically (no need to set it explicitly anymore)
- Disable drag-to-dismiss during dismiss animation
- Tweaked default style pill size & positioning
- Don't clip text to bounds

### 2.0.0

Big release. Many bugfixes, expanded public API, new features. Modernized outdated codebase - more or less a full rewrite.
This is a breaking API release. Old code using this library won't compile without any changes after upgrading.
Those changes should be pretty easy to make though - mostly new naming.

New features:

- A pill shaped layout (the legacy layout is still available as "full width", the half height layout is gone)
- Drag-to-dismiss + general support for user interaction on the notification
- Easy progress bar animation through public API
- Custom view presentation
- Presentation when no status bar is visible
- More robust layouting of text & activity indicator
- Support for apps that use window scenes
- Explicit Swift naming for all public APIs + Swift example project
- Full fledged style editor in example project + config export
- Many bug fixes


## Twitter

I'm [@calimarkus](http://twitter.com/calimarkus) on Twitter. Feel free to [post a tweet](https://twitter.com/intent/tweet?button_hashtag=JDStatusBarNotification&text=Simple%20and%20customizable%20statusbar%20notifications%20for%20iOS!%20Check%20it%20out.%20https://github.com/calimarkus/JDStatusBarNotification&via=calimarkus), if you like JDStatusBarNotification.  

[![tweetbutton](https://user-images.githubusercontent.com/807039/170856086-2c283e68-a44f-4a9f-b327-bd5a7c654455.png)](https://twitter.com/intent/tweet?button_hashtag=JDStatusBarNotification&text=Simple%20and%20customizable%20statusbar%20notifications%20for%20iOS!%20Check%20it%20out.%20https://github.com/calimarkus/JDStatusBarNotification&via=calimarkus)

## Credits

Originally based on `KGStatusBar` by Kevin Gibbon
