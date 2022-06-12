# JDStatusBarNotification

Highly customizable notifications displayed below the status bar for both notch and no-notch devices.
Customizable colors, fonts & animations. Can show an activity indicator, a progress bar & custom views.
iOS 13+. Swift ready!

Please open a [Github issue](https://github.com/calimarkus/JDStatusBarNotification/issues), if you think anything is missing or wrong.

| Drag to dismiss | Activity & Progress Bars | Custom styles |
| ------------- | ------------- | ------------- |
| ![1](https://user-images.githubusercontent.com/807039/172001713-74d8c212-cd58-4687-8d6b-472e1bdb944d.gif) | ![3](https://user-images.githubusercontent.com/807039/172001734-be3c4e36-46b6-4f9f-a3d5-59a51e5db675.gif) | ![2](https://user-images.githubusercontent.com/807039/172001727-65aa6374-beeb-4a5c-adac-7e1967236b63.gif) |

| Landscape apps (device rotation also supported) |
| ------------- |
| ![landscape](https://user-images.githubusercontent.com/807039/172003389-7752a183-f960-4bef-87c7-fcf583e4a13f.gif) |

## Installation

- [**CocoaPods:**](https://guides.cocoapods.org)
  - `pod 'JDStatusBarNotification'`
- [**Carthage:**](https://github.com/Carthage/Carthage)
  - `github "calimarkus/JDStatusBarNotification"`
- **Manually:**
  - Copy the `JDStatusBarNotification/JDStatusBarNotification` folder into your project.

## Usage

`NotificationPresenter` is a singleton. You don't need to initialize it anywhere.
All examples are Swift code, but the class can be used in Objective-C as well.
Also checkout the example project, which also includes a convenient style editor.

You can use the presenter like in the following examples:

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

![progress](https://user-images.githubusercontent.com/807039/172003585-bf8e7284-9e2e-4de2-ab88-7fce086d65a6.gif)


```swift
NotificationPresenter.shared().displayProgressBar(percentage: 0.5)

// or animated
NotificationPresenter.shared().animateProgressBar(toPercentage: 1.0, animationDuration: 1.0) { presenter in
   // ...
}
```
    
### Showing activity

![activity](https://user-images.githubusercontent.com/807039/172003589-d0513124-9b72-4e3f-89f0-278bf4c66226.gif)

```swift
NotificationPresenter.shared().displayActivityIndicator(true)
```
    
### Using alternative styles

There's a few included styles you can easily use:

![styles](https://user-images.githubusercontent.com/807039/172004375-789e050c-b0c9-465c-a1d0-4c76bc00f935.jpg)

Example usage:

```swift
NotificationPresenter.shared().present(text: "Yay, it works!", includedStyle: .success)
```

## Customization

You have the option to create fully customized styles - or to even present custom views.

The closure provides a copy of the default style, which can be modified as you like. See the `JDStatusBarStyle` class (or the style editor in the example project) for all options and documentation. You can use the example project's style editor to create a style and then export the code to configure that style.

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
NotificationPresenter.shared().addStyle(styleName: "xxx", prepare: { style in
   // ...
}

// present a custom view
var anyView: UIView = ...
NotificationPresenter.shared().present(customView: anyView)
```

#### Style Editor

Checkout the example project, which contains a full style editor. You can tweak all customization options within the app, see the changes live and even export the configuration code.

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

## Twitter

I'm [@calimarkus](http://twitter.com/calimarkus) on Twitter. Feel free to [post a tweet](https://twitter.com/intent/tweet?button_hashtag=JDStatusBarNotification&text=Simple%20and%20customizable%20statusbar%20notifications%20for%20iOS!%20Check%20it%20out.%20https://github.com/calimarkus/JDStatusBarNotification&via=calimarkus), if you like JDStatusBarNotification.  

[![tweetbutton](https://user-images.githubusercontent.com/807039/170856086-2c283e68-a44f-4a9f-b327-bd5a7c654455.png)](https://twitter.com/intent/tweet?button_hashtag=JDStatusBarNotification&text=Simple%20and%20customizable%20statusbar%20notifications%20for%20iOS!%20Check%20it%20out.%20https://github.com/calimarkus/JDStatusBarNotification&via=calimarkus)

## Credits

Originally based on `KGStatusBar` by Kevin Gibbon
