//
//  JDStatusBarNotificationPresenter.h
//
//  Based on KGStatusBar by Kevin Gibbon
//
//  Created by Markus Emrich on 10/28/13.
//  Copyright 2013 Markus Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JDStatusBarPrepareStyleBlock.h"
#import "JDStatusBarStyle.h"

@class JDStatusBarNotificationPresenter;

typedef void (^ _Nullable JDStatusBarNotificationPresenterCompletionBlock)(JDStatusBarNotificationPresenter * _Nonnull presenter);

NS_ASSUME_NONNULL_BEGIN

/**
 *  The NotificationPresenter let's you present text notification below the statusBar.
 *  You can customize the style & animations or even retrieve the presented view for further customization.
 *  It also supports displaying an activity indicator and / or an animated progress bar.
 *
 *  While a notification is displayed, a separate window is presented on top of your application window.
 *  Upon dismissal this window is fully removed from the memory. The presenter class itself is a singleton,
 *  which will stay in memory for the lifetime of your application, once it was used. That includes the
 *  DefaultStyle and any custom StatusBarStyles that were setup by the user.
 */
NS_SWIFT_NAME(NotificationPresenter)
@interface JDStatusBarNotificationPresenter : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedPresenter;

#pragma mark - WindowScene

/**
 *  This needs to be set once, if you are using window scenes in your app, otherwise the notifications won't show up at all.
 *
 *  @param windowScene The windowScene in which the notifcation should be presented.
 */
- (void)setWindowScene:(UIWindowScene * _Nullable)windowScene;

#pragma mark - Simple Presentation

/**
 *  Present a notification using the default style.
 *
 *  @param text The message to display
 *
 *  @return The presented UIView for further customization
 */
- (UIView *)presentWithText:(NSString *)text NS_SWIFT_NAME(present(text:));

/**
 *  Present a notification using the default style.
 *
 *  @param text The message to display
 *  @param completion A completion block, which gets called once the animation finishes.
 *
 *  @return The presented UIView for further customization
 */
- (UIView *)presentWithText:(NSString *)text
                 completion:(JDStatusBarNotificationPresenterCompletionBlock)completion NS_SWIFT_NAME(present(text:completion:));

/**
 *  Present a notification using the default style. The notification will
 *  automatically dismiss after the given delay.
 *
 *  @param text The message to display
 *  @param delay The delay in seconds, before the notification should be dismissed automatically.
 *
 *  @return The presented UIView for further customization
 */
- (UIView *)presentWithText:(NSString *)text
          dismissAfterDelay:(NSTimeInterval)delay NS_SWIFT_NAME(present(text:dismissAfterDelay:));

#pragma mark - Custom Style Presentation

/**
 *  Present a notification using the specified style.
 *  If no style exists for the provided name, the defaultStyle is used.
 *
 *  @param text The message to display
 *  @param styleName The name of the style. You can use previously added custom styles. If this is nil, or the no style can be found,, the default style will be used.
 *
 *  @return The presented UIView for further customization
 */
- (UIView *)presentWithText:(NSString *)text
                customStyle:(NSString * _Nullable)styleName NS_SWIFT_NAME(present(text:customStyle:));

/**
 *  Present a notification using the specified style.
 *  If no style exists for the provided name, the defaultStyle is used.
 *
 *  @param text The message to display
 *  @param styleName The name of the style. You can use previously added custom styles. If this is nil, or the no style can be found,, the default style will be used.
 *  @param completion A completion block, which gets called once the animation finishes.
 *
 *  @return The presented UIView for further customization
 */
- (UIView *)presentWithText:(NSString *)text
                customStyle:(NSString * _Nullable)styleName
                 completion:(JDStatusBarNotificationPresenterCompletionBlock)completion NS_SWIFT_NAME(present(text:customStyle:completion:));

/**
 *  Present a notification using the specified style.The notification will dismiss after the
 *  given delay. If no style exists for the provided name, the defaultStyle is used.
 *
 *  @param text The message to display
 *  @param delay The delay in seconds, before the notification should be dismissed.
 *  @param styleName The name of the style. You can use previously added custom styles. If this is nil, or the no style can be found,, the default style will be used.
 *
 *  @return The presented UIView for further customization
 */
- (UIView *)presentWithText:(NSString *)text
          dismissAfterDelay:(NSTimeInterval)delay
                customStyle:(NSString * _Nullable)styleName NS_SWIFT_NAME(present(text:dismissAfterDelay:customStyle:));

#pragma mark - Included Style Presentation

/**
 *  Present a notification using the specified style.
 *  If no style exists for the provided name, the defaultStyle is used.
 *
 *  @param text The message to display
 *  @param style The included style that should be used.
 *
 *  @return The presented UIView for further customization
 */
- (UIView *)presentWithText:(NSString *)text
              includedStyle:(JDStatusBarIncludedStyle)includedStyle NS_SWIFT_NAME(present(text:includedStyle:));
/**
 *  Present a notification using the specified style.
 *  If no style exists for the provided name, the defaultStyle is used.
 *
 *  @param text The message to display
 *  @param style The included style that should be used.
 *  @param completion A completion block, which gets called once the animation finishes.
 *
 *  @return The presented UIView for further customization
 */
- (UIView *)presentWithText:(NSString *)text
              includedStyle:(JDStatusBarIncludedStyle)includedStyle
                 completion:(JDStatusBarNotificationPresenterCompletionBlock)completion NS_SWIFT_NAME(present(text:includedStyle:completion:));

/**
 *  Present a notification using the specified style.The notification will dismiss after the
 *  given delay. If no style exists for the provided name, the defaultStyle is used.
 *
 *  @param text The message to display
 *  @param delay The delay in seconds, before the notification should be dismissed.
 *  @param style The included style that should be used.
 *
 *  @return The presented UIView for further customization
 */
- (UIView *)presentWithText:(NSString *)text
          dismissAfterDelay:(NSTimeInterval)delay
              includedStyle:(JDStatusBarIncludedStyle)includedStyle NS_SWIFT_NAME(present(text:dismissAfterDelay:includedStyle:));

#pragma mark - Custom View Presentation

/**
 *  Present a notification using a custom subview. It will be layouted correctly according to the
 *  selected style & the current device state (rotation, status bar visibility, etc.). The background
 *  will still be styled & layouted according to the provided style.
 *
 *  @param view A custom UIView to display as notification
 *  @param styleName The name of the style. You can use previously added custom styles. If this is nil, or the no style can be found,, the default style will be used.
 *  @param completion A completion block, which gets called once the animation finishes.
 *
 *  @return The presented UIView for further customization
 */
- (UIView *)presentWithCustomView:(UIView *)customView
                        styleName:(NSString * _Nullable)styleName
                       completion:(JDStatusBarNotificationPresenterCompletionBlock)completion NS_SWIFT_NAME(present(customView:style:completion:));

#pragma mark - Dismissal

/**
 *  Dismisses any currently displayed notification immediately.
 *
 *  @param animated If set, the notification will be dismissed according to the currently set StatusBarStyle
 */
- (void)dismissAnimated:(BOOL)animated NS_SWIFT_NAME(dismiss(animated:));

/**
 *  Dismisses any currently displayed notification after the provided delay.
 *
 *  @param delay The delay in seconds, before the notification should be dismissed.
 */
- (void)dismissAfterDelay:(NSTimeInterval)delay NS_SWIFT_NAME(dismiss(afterDelay:));

/**
 *  Dismisses any currently displayed notification after the provided delay.
 *  The completion block is called once the dismiss animation finishes.
 *
 *  @param delay The delay in seconds, before the notification should be dismissed.
 *  @param completion A completion block, which gets called once the dismiss animation finishes.
 */
- (void)dismissAfterDelay:(NSTimeInterval)delay
               completion:(JDStatusBarNotificationPresenterCompletionBlock)completion NS_SWIFT_NAME(dismiss(afterDelay:completion:));

#pragma mark - Style Modification

/**
 *  Defines a new default style. It will be used in all future presentations, if no style is specified.
 *
 *  @param prepareBlock Provides the existing defaultStyle instance for further customization.
 */
- (void)updateDefaultStyle:(NS_NOESCAPE JDStatusBarPrepareStyleBlock)prepareBlock;

/**
 *  Adds a new custom style, which can be used in future presentations by utilizing the same styleName.
 *  If a style with the same name already exists, it will be replaced.
 *
 *  @param styleName   The styleName which will later be used to reference the added style.
 *  @param prepareBlock Provides the existing defaultStyle instance for further customization.
 *
 *  @return Returns the styleName, so this can be used directly within a presentation call.
 */
- (NSString *)addStyleNamed:(NSString*)styleName
                    prepare:(NS_NOESCAPE JDStatusBarPrepareStyleBlock)prepareBlock NS_SWIFT_NAME(addStyle(styleName:prepare:));

/**
 *  Adds a new custom style, which can be used in future presentations by utilizing the same styleName.
 *  If a style with the same name already exists, it will be replaced.
 *
 *  @param styleName  The styleName which will later be used to reference the added style.
 *  @param includedStyle  The style that you want to base your style on.
 *  @param prepareBlock  Provides the specified style instance for further customization.
 *
 *  @return Returns the styleName, so this can be used directly within a presentation call.
 */
- (NSString *)addStyleNamed:(NSString*)styleName
               basedOnStyle:(JDStatusBarIncludedStyle)basedOnStyle
                    prepare:(NS_NOESCAPE JDStatusBarPrepareStyleBlock)prepareBlock NS_SWIFT_NAME(addStyle(styleName:basedOnIncludedStyle:prepare:));

#pragma mark - Progress Bar

/**
 *  Displays a progress bar according to the current progressBarStyle. Displays the given percentage immediately without any animation.
 *
 *  @param percentage Relative progress from 0.0 to 1.0
 */
- (void)displayProgressBarWithPercentage:(CGFloat)percentage NS_SWIFT_NAME(displayProgressBar(percentage:));
/**
 *  Displays a progress bar according to the current progressBarStyle. Animates the percentage to the provided
 *  target value using the provided animationDuration. It starts from the currently set percentage.
 *
 *  @param percentage Relative progress from 0.0 to 1.0
 *  @param animationDuration The duration of the animation from the current percentage to the provided percentage. A value of 0.0 is equivalent to calling displayProgressBar.
 *  @param completion A completion block, which gets called once the animation finishes.
 */
- (void)animateProgressBarToPercentage:(CGFloat)percentage
                     animationDuration:(CGFloat)animationDuration
                            completion:(JDStatusBarNotificationPresenterCompletionBlock)completion NS_SWIFT_NAME(animateProgressBar(toPercentage:animationDuration:completion:));

#pragma mark - Activity Indicator

/**
 *  Displays an activity indicator in front of the notification text. It will have the same color as the text color of the current style.
 *
 *  @param show  Show or hide the activity indicator.
 */
- (void)displayActivityIndicator:(BOOL)show;

#pragma mark - Others

/**
 *  Updates the text of an existing notification without any animation.
 *
 *  @param text The new message to display
 */
- (void)updateText:(NSString *)text;

/**
 *  Check if any notification is currently displayed.
 *
 *  @return YES, if a notification is currently displayed. Otherwise NO.
 */
- (BOOL)isVisible;


@end

NS_ASSUME_NONNULL_END
