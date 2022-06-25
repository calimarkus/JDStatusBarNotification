# ``JDStatusBarNotification/NotificationPresenter``

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
- ``JDStatusBarNotificationStyle``
- ``JDStatusBarNotificationPresenterCompletionBlock``

### Present a notification (using an included style)

- ``presentWithText:includedStyle:``
- ``presentWithText:includedStyle:completion:``
- ``presentWithTitle:subtitle:includedStyle:completion:``
- ``presentWithText:dismissAfterDelay:includedStyle:``
- ``JDStatusBarNotificationIncludedStyle``
- ``JDStatusBarNotificationPresenterCompletionBlock``

### Present a notification (using a custom view)

- ``presentWithCustomView:styleName:completion:``
- ``JDStatusBarNotificationPresenterCompletionBlock``

### Dismiss a notification

- ``dismiss``
- ``dismissWithCompletion:``
- ``dismissAnimated:``
- ``dismissAfterDelay:``
- ``dismissAfterDelay:completion:``
- ``JDStatusBarNotificationPresenterCompletionBlock``

### Style Modification

- ``updateDefaultStyle:``
- ``addStyleNamed:prepare:``
- ``addStyleNamed:basedOnStyle:prepare:``
- ``JDStatusBarNotificationStyle``

### Progress Bar

- ``displayProgressBarWithPercentage:``
- ``animateProgressBarToPercentage:animationDuration:completion:``
- ``JDStatusBarNotificationProgressBarStyle``

### Left View

- ``displayActivityIndicator:``
- ``displayLeftView:``
- ``JDStatusBarNotificationLeftViewStyle``

### Others

- ``updateText:``
- ``updateSubtitle:``
- ``isVisible``

### WindowScene

- ``setWindowScene:``
