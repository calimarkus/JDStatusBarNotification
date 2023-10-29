# ``JDStatusBarNotification/NotificationPresenter``

## Topics

### Retrieve the presenter

- ``shared()``

### Present a notification

- ``present(text:)``
- ``present(text:completion:)``
- ``present(title:subtitle:completion:)``
- ``present(text:dismissAfterDelay:)``

### Present a notification (using a custom style)

- ``present(text:customStyle:)``
- ``present(text:customStyle:completion:)``
- ``present(title:subtitle:customStyle:completion:)``
- ``present(text:dismissAfterDelay:customStyle:)``

### Present a notification (using an included style)

- ``IncludedStatusBarNotificationStyle``
- ``present(text:includedStyle:)``
- ``present(text:includedStyle:completion:)``
- ``present(title:subtitle:includedStyle:completion:)``
- ``present(text:dismissAfterDelay:includedStyle:)``

### Present a notification (using a custom view)

- ``present(customView:style:completion:)``
- ``present(customView:sizingController:style:completion:)``
- ``presentSwiftView(style:viewBuilder:completion:)``
- ``NotificationPresenterCustomViewSizingController``

### Dismiss a notification

- ``dismiss()``
- ``dismiss(completion:)``
- ``dismiss(animated:)``
- ``dismiss(afterDelay:)``
- ``dismiss(afterDelay:completion:)``

### Customize the style (Appearance & Behavior)

- ``updateDefaultStyle(_:)``
- ``addStyle(styleName:prepare:)``
- ``addStyle(styleName:basedOnIncludedStyle:prepare:)``
- ``NotificationPresenterPrepareStyleClosure``

### Display supplementary views

- ``displayProgressBar(percentage:)``
- ``animateProgressBar(toPercentage:animationDuration:completion:)``
- ``displayActivityIndicator(_:)``
- ``displayLeftView(_:)``

### Additional Presenter APIs

- ``updateText(_:)``
- ``updateSubtitle(_:)``
- ``isVisible()``
- ``setWindowScene(_:)``
