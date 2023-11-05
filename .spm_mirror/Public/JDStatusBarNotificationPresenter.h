//
//  JDStatusBarNotificationPresenter.h
//
//  Based on KGStatusBar by Kevin Gibbon
//
//  Created by Markus Emrich on 10/28/13.
//  Copyright 2013 Markus Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <JDStatusBarNotification/JDStatusBarNotificationPresenterPrepareStyleBlock.h>
#import <JDStatusBarNotification/JDStatusBarNotificationStyle.h>
#import <JDStatusBarNotification/JDStatusBarNotificationPresenterCustomViewSizingController.h>

@class JDStatusBarNotificationPresenter;

/// Called upon animation completion.
///
/// - Parameter presenter: Provides the ``JDStatusBarNotificationPresenter`` singleton instance. That simplifies any subsequent calls to it upon completion.
///
typedef void (^ _Nullable JDStatusBarNotificationPresenterCompletionBlock)(JDStatusBarNotificationPresenter * _Nonnull presenter) NS_REFINED_FOR_SWIFT;

NS_ASSUME_NONNULL_BEGIN

/**
 * The NotificationPresenter let's you present notifications below the statusBar.
 * You can customize the style (colors, fonts, etc.) and animations. It supports notch
 * and no-notch devices, landscape & portrait layouts and Drag-to-Dismiss. It can display a
 * title, a subtitle, an activity indicator, an animated progress bar & custom views out of the box.
 *
 * To customize the appearance, see the *Customize the style* section. To see all customization
 * options, see the ``JDStatusBarNotificationStyle`` documentation.
 *
 * While a notification is displayed, a separate window is presented on top of your application
 * window. Upon dismissal this window, its view controller and all its views are removed from
 * memory. The presenter class itself is a singleton which will stay in memory for the lifetime of
 * your application once it was created. The default ``JDStatusBarNotificationStyle`` and any styles
 * added by the user also stay in memory permanently.
 */
NS_REFINED_FOR_SWIFT
@interface JDStatusBarNotificationPresenter : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

#pragma mark - Retrieve the presenter

/// Provides access to the presenter singleton. This is the entry point to present, style and dismiss notifications.
///
/// - Returns: An initialized ``JDStatusBarNotificationPresenter`` instance.
+ (instancetype)sharedPresenter;

#pragma mark - Simple Presentation

/// Present a notification using the current default style.
///
/// - Parameter text: The message to display
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithText:(NSString *)text;

/// Present a notification using the current default style.
///
/// - Parameters:
///   - text: The text to display
///   - completion: A ``JDStatusBarNotificationPresenterCompletionBlock``, which gets called once the presentation animation finishes.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithText:(NSString *)text
                 completion:(JDStatusBarNotificationPresenterCompletionBlock)completion;

/// Present a notification using the current default style.
///
/// - Parameters:
///   - title: The text to display as title
///   - subtitle: The text to display as subtitle
///   - completion: A ``JDStatusBarNotificationPresenterCompletionBlock``, which gets called once the presentation animation finishes.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithTitle:(NSString *)title
                    subtitle:(NSString * _Nullable)subtitle
                  completion:(JDStatusBarNotificationPresenterCompletionBlock)completion;

/// Present a notification using the current default style.
///
/// The notification will automatically dismiss after the given `delay`.
///
/// - Parameters:
///   - text: The text to display
///   - delay: The delay in seconds, before the notification should be dismissed.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithText:(NSString *)text
          dismissAfterDelay:(NSTimeInterval)delay;

#pragma mark - Custom Style Presentation

/// Present a notification using a specified `customStyle`.
///
/// If no style exists for the provided `styleName`, the defaultStyle is used.
///
/// - Parameters:
///   - text: The text to display
///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyleNamed:prepare:``.
///                If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithText:(NSString *)text
                customStyle:(NSString * _Nullable)styleName;

/// Present a notification using a specified `customStyle`.
///
/// If no style exists for the provided `styleName`, the defaultStyle is used.
///
/// - Parameters:
///   - text: The text to display
///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyleNamed:prepare:``.
///                If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
///   - completion: A ``JDStatusBarNotificationPresenterCompletionBlock``, which gets called once the presentation animation finishes.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithText:(NSString *)text
                customStyle:(NSString * _Nullable)styleName
                 completion:(JDStatusBarNotificationPresenterCompletionBlock)completion;

/// Present a notification using a specified `customStyle`.
///
/// If no style exists for the provided `styleName`, the defaultStyle is used.
///
/// - Parameters:
///   - title: The text to display as title
///   - subtitle: The text to display as subtitle
///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyleNamed:prepare:``.
///                If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
///   - completion: A ``JDStatusBarNotificationPresenterCompletionBlock``, which gets called once the presentation animation finishes.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithTitle:(NSString *)title
                    subtitle:(NSString * _Nullable)subtitle
                 customStyle:(NSString * _Nullable)styleName
                  completion:(JDStatusBarNotificationPresenterCompletionBlock)completion;

/// Present a notification using a specified `customStyle`.
///
/// If no style exists for the provided `styleName`, the defaultStyle is used.
/// The notification will dismiss after the given `delay`.
///
/// - Parameters:
///   - text: The text to display
///   - delay: The delay in seconds, before the notification should be dismissed.
///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyleNamed:prepare:``.
///                If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithText:(NSString *)text
          dismissAfterDelay:(NSTimeInterval)delay
                customStyle:(NSString * _Nullable)styleName;

#pragma mark - Included Style Presentation

/// Present a notification using an existing `includedStyle`.
///
/// - Parameters:
///   - text: The text to display
///   - includedStyle: An existing ``JDStatusBarNotificationIncludedStyle``
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithText:(NSString *)text
              includedStyle:(JDStatusBarNotificationIncludedStyle)includedStyle;

/// Present a notification using an existing `includedStyle`.
///
/// - Parameters:
///   - text: The text to display
///   - includedStyle: An existing ``JDStatusBarNotificationIncludedStyle``
///   - completion: A ``JDStatusBarNotificationPresenterCompletionBlock``, which gets called once the presentation animation finishes.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithText:(NSString *)text
              includedStyle:(JDStatusBarNotificationIncludedStyle)includedStyle
                 completion:(JDStatusBarNotificationPresenterCompletionBlock)completion;

/// Present a notification using an existing `includedStyle`.
///
/// - Parameters:
///   - title: The text to display as title
///   - subtitle: The text to display as subtitle
///   - includedStyle: An existing ``JDStatusBarNotificationIncludedStyle``
///   - completion: A ``JDStatusBarNotificationPresenterCompletionBlock``, which gets called once the presentation animation finishes.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithTitle:(NSString *)title
                    subtitle:(NSString * _Nullable)subtitle
               includedStyle:(JDStatusBarNotificationIncludedStyle)includedStyle
                  completion:(JDStatusBarNotificationPresenterCompletionBlock)completion;

/// Present a notification using an existing `includedStyle`.
///
/// The notification will dismiss after the given `delay`.
///
/// - Parameters:
///   - text: The text to display
///   - delay: The delay in seconds, before the notification should be dismissed.
///   - includedStyle: An existing ``JDStatusBarNotificationIncludedStyle``
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithText:(NSString *)text
          dismissAfterDelay:(NSTimeInterval)delay
              includedStyle:(JDStatusBarNotificationIncludedStyle)includedStyle;

#pragma mark - Custom View Presentation

/// Present a notification using a custom subview.
///
/// The `customView` will be layouted correctly according to the selected style & the current device
/// state (rotation, status bar visibility, etc.). The background will still be styled & layouted
/// according to the provided style. If your custom view requires custom touch handling,
/// make sure to set `style.canTapToHold` to `false`. Otherwise the `customView` won't
/// receive any touches, as the internal `gestureRecognizer` would receive them.
///
/// - Parameters:
///   - customView: A custom UIView to display as notification content.
///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyleNamed:prepare:``.
///                If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
///   - completion: A ``JDStatusBarNotificationPresenterCompletionBlock``, which gets called once the presentation animation finishes.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithCustomView:(UIView *)customView
                        styleName:(NSString * _Nullable)styleName
                       completion:(JDStatusBarNotificationPresenterCompletionBlock)completion;

/// Present a notification using a custom subview.
///
/// The `customView` will be layouted correctly according to the selected style & the current device
/// state (rotation, status bar visibility, etc.). The background will still be styled & layouted
/// according to the provided style. If your custom view requires custom touch handling,
/// make sure to set `style.canTapToHold` to `false`. Otherwise the `customView` won't
/// receive any touches, as the internal `gestureRecognizer` would receive them.
///
/// - Parameters:
///   - customView: A custom UIView to display as notification content.
///   - sizingController: An optional controller conforming to ``NotificationPresenterCustomViewSizingController``, which controls the size of a presented custom view.
///   - styleName: The name of the style. You can use styles previously added using e.g. ``addStyleNamed:prepare:``.
///                If no style can be found for the given `styleName` or it is `nil`, the default style will be used.
///   - completion: A ``JDStatusBarNotificationPresenterCompletionBlock``, which gets called once the presentation animation finishes.
///
/// - Returns: The presented UIView for further customization
///
- (UIView *)presentWithCustomView:(UIView *)customView
                 sizingController:(id<JDStatusBarNotificationPresenterCustomViewSizingController> _Nullable)sizingController
                        styleName:(NSString * _Nullable)styleName
                       completion:(JDStatusBarNotificationPresenterCompletionBlock)completion;

#pragma mark - Dismissal

/// Dismisses any currently displayed notification immediately using an animation.
///
/// The animation is determined by the currently set ``JDStatusBarNotificationAnimationType``.
- (void)dismiss;

/// Dismisses any currently displayed notification immediately using an animation.
///
/// The animation is determined by the currently set ``JDStatusBarNotificationAnimationType``.
///
/// - Parameter completion: A ``JDStatusBarNotificationPresenterCompletionBlock``, which gets called once the dismiss animation finishes.
///
- (void)dismissWithCompletion:(JDStatusBarNotificationPresenterCompletionBlock)completion;

/// Dismisses any currently displayed notification.
///
/// - Parameter animated: If `true`, the notification will be dismissed animated according to the currently
///                       set ``JDStatusBarNotificationAnimationType``. Otherwise it will be dismissed without animation.
///
- (void)dismissAnimated:(BOOL)animated;

/// Dismisses any currently displayed notification animated after the provided delay.
///
/// The animation is determined by the currently set ``JDStatusBarNotificationAnimationType``.
///
/// - Parameter delay: The delay in seconds, before the notification should be dismissed.
///
- (void)dismissAfterDelay:(NSTimeInterval)delay;

/// Dismisses any currently displayed notification animated after the provided delay.
///
/// The animation is determined by the currently set ``JDStatusBarNotificationAnimationType``.
///
/// - Parameters:
///   - delay: The delay in seconds, before the notification should be dismissed.
///   - completion: A ``JDStatusBarNotificationPresenterCompletionBlock``, which gets called once the dismiss animation finishes.
///
- (void)dismissAfterDelay:(NSTimeInterval)delay
               completion:(JDStatusBarNotificationPresenterCompletionBlock)completion;

/// Dismisses any currently displayed notification animated after the provided delay.
///
/// The animation is determined by the currently set ``JDStatusBarNotificationAnimationType``.
///

///
/// - Parameters:
///   - animated: If `true`, the notification will be dismissed animated according to the currently set ``JDStatusBarNotificationAnimationType``. Otherwise it will be dismissed without animation.
///   - delay: The delay in seconds, before the notification should be dismissed.
///   - completion: A ``JDStatusBarNotificationPresenterCompletionBlock``, which gets called once the dismiss animation finishes.
///
- (void)dismissAnimated:(BOOL)animated
             afterDelay:(NSTimeInterval)delay
             completion:(JDStatusBarNotificationPresenterCompletionBlock)completion;

#pragma mark - Style Modification

/// Defines a new default style.
/// The new style will be used in all future presentations that have no specific style specified.
///
/// - Parameter prepareBlock: Provides the current default ``JDStatusBarNotificationStyle`` instance for further customization.
///
- (void)updateDefaultStyle:(NS_NOESCAPE JDStatusBarNotificationPresenterPrepareStyleBlock)prepareBlock;

/// Adds a new named style.
/// This can later be used by referencing it using the `styleName` - or by using the return value directly.
///
/// The added style can be used in future presentations by utilizing the same `styleName` in e.g. ``presentWithText:customStyle:``.
/// If a style with the same name already exists, it will be replaced.
///
/// - Parameters:
///   - styleName:   The styleName which will later be used to reference the added style.
///   - prepareBlock: Provides the current default ``JDStatusBarNotificationStyle`` instance for further customization.
///
/// - Returns: Returns the `styleName`, so that this call can be used directly within a presentation call.
///
- (NSString *)addStyleNamed:(NSString*)styleName
                    prepare:(NS_NOESCAPE JDStatusBarNotificationPresenterPrepareStyleBlock)prepareBlock;

/// Adds a new named style based on an included style.
/// This can later be used by referencing it using the `styleName` - or by using the return value directly.
///
/// The added style can be used in future presentations by utilizing the same `styleName` in e.g. ``presentWithText:customStyle:``.
/// If a style with the same name already exists, it will be replaced.
///
/// - Parameters:
///   - styleName:  The styleName which will later be used to reference the added style.
///   - basedOnStyle:  The ``JDStatusBarNotificationIncludedStyle``, which you want to base your style on.
///   - prepareBlock: Provides an ``JDStatusBarNotificationStyle`` instance based on the provided `basedOnStyle` for further customization.
///
/// - Returns: Returns the `styleName`, so that this call can be used directly within a presentation call.
///
- (NSString *)addStyleNamed:(NSString*)styleName
               basedOnStyle:(JDStatusBarNotificationIncludedStyle)basedOnStyle
                    prepare:(NS_NOESCAPE JDStatusBarNotificationPresenterPrepareStyleBlock)prepareBlock;

#pragma mark - Progress Bar

/// Displays a progress bar at the given `percentage`.
///
/// Displays the given percentage immediately without animation.
/// The progress bar will be styled according to the current ``JDStatusBarNotificationProgressBarStyle``.
///
/// - Parameter percentage: The percentage in a range from 0.0 to 1.0
///
- (void)displayProgressBarWithPercentage:(CGFloat)percentage;

/// Displays a progress bar and animates it to the provided `percentage`.
///
/// Animates the progress bar from the currently set `percentage` to the provided `percentage` using the provided `animationDuration`.
/// The progress bar will be styled according to the current ``JDStatusBarNotificationProgressBarStyle``.
///
/// - Parameters:
///   - percentage: Relative progress from 0.0 to 1.0
///   - animationDuration: The duration of the animation from the current percentage to the provided percentage.
///   - completion: A ``JDStatusBarNotificationPresenterCompletionBlock``, which gets called once the progress bar animation finishes.
///
- (void)animateProgressBarToPercentage:(CGFloat)percentage
                     animationDuration:(CGFloat)animationDuration
                            completion:(JDStatusBarNotificationPresenterCompletionBlock)completion;

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

/// Updates the text of an existing notification without animation.
///
/// - Parameter text: The new text to display as title
///
- (void)updateText:(NSString *)text;

/// Updates the subtitle of an existing notification without animation.
///
/// - Parameter subtitle: The new text to display as subtitle
///
- (void)updateSubtitle:(NSString * _Nullable)subtitle;

/// Let's you check if a notification is currently displayed.
///
/// - Returns: `true` if a notification is currently displayed. Otherwise `false`.
///
- (BOOL)isVisible;

#pragma mark - WindowScene

/// Lets you set an explicit `UIWindowScene`, in which notifications should be presented in. In most cases you don't need to set this.
///
/// The `UIWindowScene` is usually inferred automatically, but if that doesn't work for your setup, you can set it explicitly.
///
/// - Parameter windowScene: The `UIWindowScene` in which the notifcation should be presented.
///
- (void)setWindowScene:(UIWindowScene * _Nullable)windowScene;


@end

NS_ASSUME_NONNULL_END
