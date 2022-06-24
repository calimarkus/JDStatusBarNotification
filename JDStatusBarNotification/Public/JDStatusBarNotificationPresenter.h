//
//  JDStatusBarNotificationPresenter.h
//
//  Based on KGStatusBar by Kevin Gibbon
//
//  Created by Markus Emrich on 10/28/13.
//  Copyright 2013 Markus Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JDStatusBarNotificationPresenterPrepareStyleBlock.h"
#import "JDStatusBarNotificationStyle.h"

@class JDStatusBarNotificationPresenter;

typedef void (^ _Nullable JDStatusBarNotificationPresenterCompletionBlock)(JDStatusBarNotificationPresenter * _Nonnull presenter) NS_SWIFT_NAME(NotificationPresenterCompletion);

NS_ASSUME_NONNULL_BEGIN

/**
 * The NotificationPresenter let's you present notifications below the statusBar.
 * You can customize the style (colors, fonts, etc.) and animations. It supports notch
 * and no-notch devices, landscape & portrait layouts and Drag-to-Dismiss. It can display a
 * title, a subtitle, an activity indicator, an animated progress bar & custom views out of the box.
 *
 * While a notification is displayed, a separate window is presented on top of your application
 * window. Upon dismissal this window, its view controller and all its views are removed from
 * memory. The presenter class itself is a singleton which will stay in memory for the lifetime of
 * your application once it was created. The default ``JDStatusBarNotificationStyle`` and any styles
 * added by the user also stay in memory permanently.
 */
NS_SWIFT_NAME(NotificationPresenter)
@interface JDStatusBarNotificationPresenter : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedPresenter;

#pragma mark - Simple Presentation

/// Present a notification using the default style.
///
/// - Parameter text: The message to display
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithText:(NSString *)text NS_SWIFT_NAME(present(text:));

/// Present a notification using the default style.
///
/// - Parameters:
///   - text: The message to display
///   - completion: A completion block, which gets called once the animation finishes.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithText:(NSString *)text
                 completion:(JDStatusBarNotificationPresenterCompletionBlock)completion NS_SWIFT_NAME(present(text:completion:));

/// Present a notification using the default style.
///
/// - Parameters:
///   - title: The new title to display
///   - subtitle: The new subtitle to display
///   - completion: A completion block, which gets called once the animation finishes.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithTitle:(NSString *)title
                    subtitle:(NSString * _Nullable)subtitle
                  completion:(JDStatusBarNotificationPresenterCompletionBlock)completion NS_SWIFT_NAME(present(title:subtitle:completion:));

/// Present a notification using the default style. The notification will
/// automatically dismiss after the given delay.
///
/// - Parameters:
///   - text: The message to display
///   - delay: The delay in seconds, before the notification should be dismissed automatically.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithText:(NSString *)text
          dismissAfterDelay:(NSTimeInterval)delay NS_SWIFT_NAME(present(text:dismissAfterDelay:));

#pragma mark - Custom Style Presentation

/// Present a notification using the specified style.
/// If no style exists for the provided name, the defaultStyle is used.
///
/// - Parameters:
///   - text: The message to display
///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyleNamed:prepare:``.
///                If this is nil, or no style can be found,, the default style will be used.   
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithText:(NSString *)text
                customStyle:(NSString * _Nullable)styleName NS_SWIFT_NAME(present(text:customStyle:));

/// Present a notification using the specified style.
/// If no style exists for the provided name, the defaultStyle is used.
///
/// - Parameters:
///   - text: The message to display
///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyleNamed:prepare:``.
///                If this is nil, or no style can be found,, the default style will be used.
///   - completion: A completion block, which gets called once the animation finishes.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithText:(NSString *)text
                customStyle:(NSString * _Nullable)styleName
                 completion:(JDStatusBarNotificationPresenterCompletionBlock)completion NS_SWIFT_NAME(present(text:customStyle:completion:));

/// Present a notification using the specified style.
/// If no style exists for the provided name, the defaultStyle is used.
///
/// - Parameters:
///   - title: The new title to display
///   - subtitle: The new subtitle to display
///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyleNamed:prepare:``.
///                If this is nil, or no style can be found,, the default style will be used.
///   - completion: A completion block, which gets called once the animation finishes.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithTitle:(NSString *)title
                    subtitle:(NSString * _Nullable)subtitle
                 customStyle:(NSString * _Nullable)styleName
                  completion:(JDStatusBarNotificationPresenterCompletionBlock)completion NS_SWIFT_NAME(present(title:subtitle:customStyle:completion:));

/// Present a notification using the specified style.The notification will dismiss after the
/// given delay. If no style exists for the provided name, the defaultStyle is used.
///
/// - Parameters:
///   - text: The message to display
///   - delay: The delay in seconds, before the notification should be dismissed.
///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyleNamed:prepare:``.
///                If this is nil, or no style can be found,, the default style will be used.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithText:(NSString *)text
          dismissAfterDelay:(NSTimeInterval)delay
                customStyle:(NSString * _Nullable)styleName NS_SWIFT_NAME(present(text:dismissAfterDelay:customStyle:));

#pragma mark - Included Style Presentation

/// Present a notification using the specified style.
/// If no style exists for the provided name, the defaultStyle is used.
///
/// - Parameters:
///   - text: The message to display
///   - includedStyle: The included style that should be used.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithText:(NSString *)text
              includedStyle:(JDStatusBarNotificationIncludedStyle)includedStyle NS_SWIFT_NAME(present(text:includedStyle:));
/// Present a notification using the specified style.
/// If no style exists for the provided name, the defaultStyle is used.
///
/// - Parameters:
///   - text: The message to display
///   - includedStyle: The included style that should be used.
///   - completion: A completion block, which gets called once the animation finishes.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithText:(NSString *)text
              includedStyle:(JDStatusBarNotificationIncludedStyle)includedStyle
                 completion:(JDStatusBarNotificationPresenterCompletionBlock)completion NS_SWIFT_NAME(present(text:includedStyle:completion:));
/// Present a notification using the specified style.
/// If no style exists for the provided name, the defaultStyle is used.
///
/// - Parameters:
///   - title: The new title to display
///   - subtitle: The new subtitle to display
///   - includedStyle: The included style that should be used.
///   - completion: A completion block, which gets called once the animation finishes.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithTitle:(NSString *)title
                    subtitle:(NSString * _Nullable)subtitle
               includedStyle:(JDStatusBarNotificationIncludedStyle)includedStyle
                  completion:(JDStatusBarNotificationPresenterCompletionBlock)completion NS_SWIFT_NAME(present(title:subtitle:includedStyle:completion:));

/// Present a notification using the specified style.The notification will dismiss after the
/// given delay. If no style exists for the provided name, the defaultStyle is used.
///
/// - Parameters:
///   - text: The message to display
///   - delay: The delay in seconds, before the notification should be dismissed.
///   - includedStyle: The included style that should be used.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithText:(NSString *)text
          dismissAfterDelay:(NSTimeInterval)delay
              includedStyle:(JDStatusBarNotificationIncludedStyle)includedStyle NS_SWIFT_NAME(present(text:dismissAfterDelay:includedStyle:));

#pragma mark - Custom View Presentation

/// Present a notification using a custom subview.
///
/// It will be layouted correctly according to the selected style & the current device
/// state (rotation, status bar visibility, etc.). The background will still be styled & layouted
/// according to the provided style. If your custom view requires custom touch handling,
/// make sure to set style.canTapToHold to false. If you don't do this, your custom view won't
/// receive any touches, as the internal gestureRecognizer would receive them.
///
/// - Parameters:
///   - customView: A custom UIView to display as notification
///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyleNamed:prepare:``.
///                If this is nil, or no style can be found,, the default style will be used.
///   - completion: A completion block, which gets called once the animation finishes.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithCustomView:(UIView *)customView
                        styleName:(NSString * _Nullable)styleName
                       completion:(JDStatusBarNotificationPresenterCompletionBlock)completion NS_SWIFT_NAME(present(customView:style:completion:));

#pragma mark - Dismissal

/// Dismisses any currently displayed notification immediately using an animation.
- (void)dismiss;

/// Dismisses any currently displayed notification immediately using an animation.
///
/// - Parameter completion: A completion block, which gets called once the dismiss animation finishes.
///
- (void)dismissWithCompletion:(JDStatusBarNotificationPresenterCompletionBlock)completion NS_SWIFT_NAME(dismiss(completion:));

/// Dismisses any currently displayed notification.
///
/// - Parameter animated: If true, the notification will be animated according to the currently set [[JDStatusBarNotificationStyle]]. Otherwise no animation will be used.
///
- (void)dismissAnimated:(BOOL)animated NS_SWIFT_NAME(dismiss(animated:));

/// Dismisses any currently displayed notification after the provided delay.
///
/// - Parameter delay: The delay in seconds, before the notification should be dismissed.
///
- (void)dismissAfterDelay:(NSTimeInterval)delay NS_SWIFT_NAME(dismiss(afterDelay:));

/// Dismisses any currently displayed notification after the provided delay.
///
/// - Parameters:
///   - delay: The delay in seconds, before the notification should be dismissed.
///   - completion: A completion block, which gets called once the dismiss animation finishes.
///
- (void)dismissAfterDelay:(NSTimeInterval)delay
               completion:(JDStatusBarNotificationPresenterCompletionBlock)completion NS_SWIFT_NAME(dismiss(afterDelay:completion:));

#pragma mark - Style Modification

/// Defines a new default style.
///
/// The new style will be used in all future presentations that have no specific style specified.
///
/// - Parameter prepareBlock: Provides the existing defaultStyle instance for further customization.
///
- (void)updateDefaultStyle:(NS_NOESCAPE JDStatusBarNotificationPresenterPrepareStyleBlock)prepareBlock;

/// Adds a new custom style.
///
/// The added style can be used in future presentations by utilizing the same `styleName` in e.g. ``presentWithText:customStyle:``.
/// If a style with the same name already exists, it will be replaced.
///
/// - Parameters:
///   - styleName:   The styleName which will later be used to reference the added style.
///   - prepareBlock: Provides the existing defaultStyle instance for further customization.
///
/// - Returns: Returns the `styleName`, so that this call can be used directly within a presentation call.
///
- (NSString *)addStyleNamed:(NSString*)styleName
                    prepare:(NS_NOESCAPE JDStatusBarNotificationPresenterPrepareStyleBlock)prepareBlock NS_SWIFT_NAME(addStyle(styleName:prepare:));

/// Adds a new custom style.
///
/// The added style can be used in future presentations by utilizing the same `styleName` in e.g. ``presentWithText:customStyle:``.
/// If a style with the same name already exists, it will be replaced.
///
/// - Parameters:
///   - styleName:  The styleName which will later be used to reference the added style.
///   - basedOnStyle:  The ``JDStatusBarNotificationIncludedStyle``, which you want to base your style on.
///   - prepareBlock:  Provides the specified style instance for further customization.
///
/// - Returns: Returns the `styleName`, so that this call can be used directly within a presentation call.
///
- (NSString *)addStyleNamed:(NSString*)styleName
               basedOnStyle:(JDStatusBarNotificationIncludedStyle)basedOnStyle
                    prepare:(NS_NOESCAPE JDStatusBarNotificationPresenterPrepareStyleBlock)prepareBlock NS_SWIFT_NAME(addStyle(styleName:basedOnIncludedStyle:prepare:));

#pragma mark - Progress Bar

/// Displays a progress bar at the given percentage.
///
/// Displays the given percentage immediately without animation.
/// The progress bar will be styled according to the current ``JDStatusBarNotificationProgressBarStyle``.
///
/// - Parameter percentage: The percentage in a range from 0.0 to 1.0
///
- (void)displayProgressBarWithPercentage:(CGFloat)percentage NS_SWIFT_NAME(displayProgressBar(percentage:));

/// Displays a progress bar and animates to a target value.
///
/// Animates the progress bar from the currently set `percentage` to the provided `percentage` using the provided `animationDuration`.
/// The progress bar will be styled according to the current ``JDStatusBarNotificationProgressBarStyle``.
///
/// - Parameters:
///   - percentage: Relative progress from 0.0 to 1.0
///   - animationDuration: The duration of the animation from the current percentage to the provided
///                        percentage. A value of 0.0 is equivalent to calling displayProgressBar.
///   - completion: A completion block, which gets called once the animation finishes.
///
- (void)animateProgressBarToPercentage:(CGFloat)percentage
                     animationDuration:(CGFloat)animationDuration
                            completion:(JDStatusBarNotificationPresenterCompletionBlock)completion NS_SWIFT_NAME(animateProgressBar(toPercentage:animationDuration:completion:));

#pragma mark - Left View

/// Displays an activity indicator as the notifications left view.
///
/// It will have the same color as the text color of the current style by default.
/// The color can also be set explicitly by using the `leftViewStyle.tintColor`.
/// The layout is also defined by the ``JDStatusBarNotificationLeftViewStyle``.
///
/// - Parameter show:  Show or hide the activity indicator.
///
- (void)displayActivityIndicator:(BOOL)show;

/// Displays a view on the left side of the text.
/// The layout is defined by the ``JDStatusBarNotificationLeftViewStyle``.
///
/// - Parameter leftView: A custom `UIView` to display on the left side of the text. E.g. an
///                       icon / image / profile picture etc. A nil value removes an existing leftView.
///
- (void)displayLeftView:(UIView * _Nullable)leftView;

#pragma mark - Others

/// Updates the text of an existing notification without any animation.
///
/// - Parameter text: The new message to display
///
- (void)updateText:(NSString *)text;

/// Updates the subtitle of an existing notification without any animation.
///
/// - Parameter subtitle: The new subtitle to display
///
- (void)updateSubtitle:(NSString * _Nullable)subtitle;

/// Check if any notification is currently displayed.
///
/// - Returns: YES, if a notification is currently displayed. Otherwise NO.
///
- (BOOL)isVisible;

#pragma mark - WindowScene

/// This lets you set an explicit WindowScene, in which notifications should be presented.
/// It is usually inferred automatically, but if that doesn't work for your setup, you can set one explciitly.
///
/// - Parameter windowScene: The windowScene in which the notifcation should be presented.
///
- (void)setWindowScene:(UIWindowScene * _Nullable)windowScene;


@end

NS_ASSUME_NONNULL_END
