# ``JDStatusBarNotification/JDStatusBarNotificationPresenter``

## Topics

### Retrieve the presenter

- ``sharedPresenter``

### Present a notification

- ``presentWithText:``
- ``presentWithText:completion:``
- ``presentWithTitle:subtitle:completion:``
- ``presentWithText:dismissAfterDelay:``
- ``JDStatusBarNotificationPresenterCompletionBlock``

### Present a notification (using a custom style)

- ``presentWithText:customStyle:``
- ``presentWithText:customStyle:completion:``
- ``presentWithTitle:subtitle:customStyle:completion:``
- ``presentWithText:dismissAfterDelay:customStyle:``

### Present a notification (using an included style)

- ``IncludedStatusBarNotificationStyle``
- ``presentWithText:includedStyle:``
- ``presentWithText:includedStyle:completion:``
- ``presentWithTitle:subtitle:includedStyle:completion:``
- ``presentWithText:dismissAfterDelay:includedStyle:``

### Present a notification (using a custom view)

- ``presentWithCustomView:styleName:completion:``
- ``presentWithCustomView:sizingController:styleName:completion:``
- ``NotificationPresenterCustomViewSizingController``

### Dismiss a notification

- ``dismiss``
- ``dismissWithCompletion:``
- ``dismissAnimated:``
- ``dismissAfterDelay:``
- ``dismissAfterDelay:completion:``

### Customize the style (Appearance & Behavior)

- ``updateDefaultStyle:``
- ``addStyleNamed:prepare:``
- ``addStyleNamed:basedOnStyle:prepare:``
- ``JDStatusBarNotificationPresenterPrepareStyleBlock``

### Display supplementary views

- ``displayProgressBarWithPercentage:``
- ``animateProgressBarToPercentage:animationDuration:completion:``
- ``displayActivityIndicator:``
- ``displayLeftView:``

### Additional Presenter APIs

- ``updateText:``
- ``updateSubtitle:``
- ``isVisible``
- ``setWindowScene:``
