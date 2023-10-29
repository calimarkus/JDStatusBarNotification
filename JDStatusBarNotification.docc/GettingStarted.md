# Getting Started

Some simple examples to get started.

All examples here are written in Swift. But everything can be called from Objective-C too.
Explore the ``JDStatusBarNotification/NotificationPresenter`` API to see all options.

### Showing a text notification

It's as simple as this:

**Swift:**
```swift
NotificationPresenter.shared().present(text: "Hello World")

// with completion
NotificationPresenter.shared().present(text: "Hello World") { presenter in
   // ...
}
```

### Dismissing a notification

**Swift:**
```swift
NotificationPresenter.shared().dismiss(animated: true)

// with completion
NotificationPresenter.shared().dismiss(afterDelay: 0.5) { presenter in
   // ...
}
```
    
### Showing activity

**Swift:**
```swift
NotificationPresenter.shared().present(text: "")
NotificationPresenter.shared().displayActivityIndicator(true)
```

![activity](https://user-images.githubusercontent.com/807039/175884729-c6255d41-4728-4bcb-bf72-fb12db01b5d5.gif)
    
### Showing a custom left view

**Swift:**
```swift
let image = UIImageView(image: UIImage(systemName: "gamecontroller.fill"))
NotificationPresenter.shared().present(title: "Player II", subtitle: "Connected")
NotificationPresenter.shared().displayLeftView(image)
```

![leftview](https://user-images.githubusercontent.com/807039/175884751-c93ffd31-a436-43d2-9eed-82d7cb23d8f6.gif)
    
### Showing progress

**Swift:**
```swift
NotificationPresenter.shared().present(text: "Animating Progress…") { presenter in
  presenter.animateProgressBar(toPercentage: 1.0, animationDuration: 0.75) { presenter in
    presenter.dismiss()
  }
}

// or set an explicit percentage manually (without animation)
NotificationPresenter.shared().displayProgressBar(percentage: 0.0)
```

![progress](https://user-images.githubusercontent.com/807039/175886588-e1aba466-85fa-4e32-951a-cd368c7d553d.gif)
    
### Using other included styles

There's a few included styles you can easily use with the following API:

**Swift:**
```swift
NotificationPresenter.shared().present(text: "Yay, it works!",
                                       includedStyle: .success)
```

![itworks](https://user-images.githubusercontent.com/807039/175888059-3beeb659-b561-4e7c-9c66-6fbc683ae152.jpg)

### Using a custom UIView

If you want full control over the notification content and styling, you can use your own custom UIView.

**Swift:**
```swift
// present a custom view
let button = UIButton(type: .system, primaryAction: UIAction { _ in
  NotificationPresenter.shared().dismiss()
})
button.setTitle("Dismiss!", for: .normal)
NotificationPresenter.shared().present(customView: button)
```

| Light Mode  | Dark Mode |
| --- | --- |
| ![customView](https://user-images.githubusercontent.com/807039/173234544-7a75edbe-00b1-437b-8651-2e63a1ba63c8.gif) | ![customView2](https://user-images.githubusercontent.com/807039/173234636-b3745101-0723-4342-9a3a-32a868ea820e.gif) |

## Customization

You have the option to easily create & use fully customized styles.

The closures of ``JDStatusBarNotification/NotificationPresenter/updateDefaultStyle(_:)`` and ``JDStatusBarNotification/NotificationPresenter/addStyle(named:usingStyle:prepare:)`` provide a copy of
the default style, which can then be modified. See the ``JDStatusBarNotification/StatusBarNotificationStyle`` API for all options.

**Swift:**
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
