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

### Legacy API support (for objc only)

These exist for backwards compatibility with the previous objc API. In Swift use the APIs listed above instead.

- ``zlp(t:)``
- ``zlp(t:c:)``
- ``zlp(t:d:)``
- ``zlp(t:st:c:)``

<!--included style-->
- ``zlp(t:s:)``
- ``zlp(t:s:c:)``
- ``zlp(t:d:s:)``
- ``zlp(t:st:s:c:)``

<!--custom style-->
- ``zlp(t:cu:)``
- ``zlp(t:cu:c:)``
- ``zlp(t:d:cu:)``
- ``zlp(t:st:cu:c:)``

<!--custom view-->
- ``zlp(cv:s:c:)``

<!--dismissal-->
- ``zld()``
- ``zld(a:)``
- ``zld(c:)``
- ``zld(d:)``
- ``zld(d:c:)``
- ``zld(a:d:c:)``

<!--add style-->
- ``zlas(n:p:)``
