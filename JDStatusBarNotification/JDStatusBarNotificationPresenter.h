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

@class JDStatusBarStyle;
@class JDStatusBarView;
@class JDStatusBarNotificationPresenter;

typedef void (^ _Nullable JDStatusBarNotificationPresenterCompletionBlock)(JDStatusBarNotificationPresenter * _Nonnull presenter);

NS_ASSUME_NONNULL_BEGIN

/**
 *  This class is a singletion which is used to present notifications
 *  on top of the status bar. To present a notification, use one of the
 *  given class methods.
 */
NS_SWIFT_NAME(NotificationPresenter)
@interface JDStatusBarNotificationPresenter : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedPresenter;

#pragma mark - Public API

/**
 *  This needs to be set once, if you are using window scenes in your app, otherwise the notifications won't show up at all.
 *
 *  @param windowScene The windowScene in which the notifcation should be presented.
 */
- (void)setWindowScene:(UIWindowScene * _Nullable)windowScene;

#pragma mark - Presentation

/**
 *  Show a notification. It won't hide automatically,
 *  you have to dimiss it on your own.
 *
 *  @param status The message to display
 *
 *  @return The presented notification view for further customization
 */
- (JDStatusBarView *)showWithStatus:(NSString *)status NS_SWIFT_NAME(show(status:));

/**
 *  Show a notification with a specific style. It won't
 *  hide automatically, you have to dimiss it on your own.
 *
 *  @param status The message to display
 *  @param styleName The name of the style. You can use any JDStatusBarStyle constant
 *  (JDStatusBarIncludedStyleDefault, etc.), or a custom style identifier, after you added a
 *  custom style. If this is nil, the default style will be used.
 *
 *  @return The presented notification view for further customization
 */
- (JDStatusBarView *)showWithStatus:(NSString *)status
                          styleName:(NSString * _Nullable)styleName NS_SWIFT_NAME(show(status:styleName:));

/**
 *  Same as showWithStatus:, but the notification will
 *  automatically dismiss after the given timeInterval.
 *
 *  @param status       The message to display
 *  @param timeInterval The duration, how long the notification
 *  is displayed. (Including the animation duration)
 *
 *  @return The presented notification view for further customization
 */
- (JDStatusBarView *)showWithStatus:(NSString *)status
                  dismissAfterDelay:(NSTimeInterval)timeInterval NS_SWIFT_NAME(show(status:dismissAfterDelay:));

/**
 *  Same as showWithStatus:styleName:, but the notification
 *  will automatically dismiss after the given timeInterval.
 *
 *  @param status       The message to display
 *  @param timeInterval The duration, how long the notification
 *  is displayed. (Including the animation duration)
 *  @param styleName The name of the style. You can use any JDStatusBarStyle constant
 *  (JDStatusBarIncludedStyleDefault, etc.), or a custom style identifier, after you added a
 *  custom style. If this is nil, the default style will be used.
 *
 *  @return The presented notification view for further customization
 */
- (JDStatusBarView *)showWithStatus:(NSString *)status
                  dismissAfterDelay:(NSTimeInterval)timeInterval
                          styleName:(NSString * _Nullable)styleName NS_SWIFT_NAME(show(status:dismissAfterDelay:styleName:));

#pragma mark - Dismissal

/**
 *  Dismisses any currently displayed notification immediately
 *
 *  @param animated If this is YES, the animation style used
 *  for presentation will also be used for the dismissal.
 */
- (void)dismissAnimated:(BOOL)animated NS_SWIFT_NAME(dismiss(animated:));

/**
 *  Same as dismissAnimated:, but you can specify a delay,
 *  so the notification wont be dismissed immediately
 *
 *  @param delay The delay, how long the notification should stay visible
 */
- (void)dismissAfterDelay:(NSTimeInterval)delay NS_SWIFT_NAME(dismiss(afterDelay:));

/**
 *  Same as dismissAfterDelay:, but let's you utilize a completion block.
 *
 *  @param delay The delay, how long the notification should stay visible
 *  @param completion A completion block, which will be executed upon dismissal.
 */
- (void)dismissAfterDelay:(NSTimeInterval)delay
               completion:(JDStatusBarNotificationPresenterCompletionBlock)completion NS_SWIFT_NAME(dismiss(afterDelay:completion:));

#pragma mark - Styles

/**
 *  This changes the default style, which is always used
 *  when a method without styleName is used for presentation, or
 *  styleName is nil, or no style is found with this name.
 *
 *  @param prepareBlock A block, which has a JDStatusBarStyle instance as
 *  parameter. This instance can be modified to suit your needs. You need
 *  to return the modified style again.
 */
- (void)updateDefaultStyle:(JDStatusBarPrepareStyleBlock)prepareBlock;

/**
 *  Adds a custom style, which than can be used
 *  in the presentation methods.
 *
 *  @param identifier   The identifier, which will
 *  later be used to reference the configured style.
 *  @param prepareBlock A block, which has a JDStatusBarStyle instance as
 *  parameter. This instance can be modified to suit your needs. You need
 *  to return the modified style again.
 *
 *  @return Returns the given identifier, so it can
 *  be directly used as styleName parameter.
 */
- (NSString*)addStyleNamed:(NSString*)identifier
                   prepare:(JDStatusBarPrepareStyleBlock)prepareBlock NS_SWIFT_NAME(addStyle(named:prepare:));

#pragma mark - Modifications

/**
 *  Update the text of the label without presenting a new notification.
 *
 *  @param status The new message to display
 */
- (void)updateStatus:(NSString *)status;

/**
 *  Displays a progress bar according to the current progressBarStyle. Displays the given percentage immediately without animation.
 *
 *  @param percentage Relative progress from 0.0 to 1.0
 */
- (void)displayProgressBarWithPercentage:(CGFloat)percentage NS_SWIFT_NAME(displayProgressBar(percentage:));
/**
 *  Show the progress bar according to the current progressBarStyle.
 *
 *  @param percentage Relative progress from 0.0 to 1.0
 *  @param animationDuration This duration will be utilized to animate the change in percentage.
 *  @param completion A block to be executed upon animation completion.
 */
- (void)displayProgressBarWithPercentage:(CGFloat)percentage
                       animationDuration:(CGFloat)animationDuration
                              completion:(JDStatusBarNotificationPresenterCompletionBlock)completion NS_SWIFT_NAME(displayProgressBar(percentage:animationDuration:completion:));

/**
 *  Shows an activity indicator in front of the notification text using the text color
 *
 *  @param show  Use this flag to show or hide the activity indicator
 */
- (void)displayActivityIndicator:(BOOL)show;

#pragma mark - State

/**
 *  This method tests, if a notification is currently displayed.
 *
 *  @return YES, if a notification is currently displayed. Otherwise NO.
 */
- (BOOL)isVisible;


@end

NS_ASSUME_NONNULL_END
