# ``JDStatusBarNotification/NotificationPresenter``

## Topics

### Retrieve the presenter

- ``shared``

### Present a notification

- ``Completion``
- ``present(_:subtitle:styleName:duration:completion:)``
- ``present(_:subtitle:includedStyle:duration:completion:)``
- ``IncludedStatusBarNotificationStyle``

### Present a notification (using a custom view)

- ``presentCustomView(_:sizingController:styleName:completion:)``
- ``presentSwiftView(styleName:viewBuilder:completion:)``
- ``NotificationPresenterCustomViewSizingController``

### Dismiss a notification

- ``dismiss(animated:after:completion:)``

### Customize the style (Appearance & Behavior)

- ``PrepareStyleClosure``
- ``updateDefaultStyle(_:)``
- ``addStyle(named:usingStyle:prepare:)``

### Display supplementary views

- ``displayProgressBar(at:)``
- ``animateProgressBar(to:duration:completion:)``
- ``displayActivityIndicator(_:)``
- ``displayLeftView(_:)``

### Additional Presenter APIs

- ``isVisible``
- ``updateTitle(_:)``
- ``updateSubtitle(_:)``
- ``setWindowScene(_:)``
