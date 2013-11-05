//
//  JDStatusBarNotification.h
//
//  Based on KGStatusBar by Kevin Gibbon
//
//  Created by Markus Emrich on 10/28/13.
//  Copyright 2013 Markus Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const JDStatusBarStyleError;   /// This style has a red background with a white Helvetica label.
extern NSString *const JDStatusBarStyleWarning; /// This style has a yellow background with a gray Helvetica label.
extern NSString *const JDStatusBarStyleSuccess; /// This style has a green background with a white Helvetica label.
extern NSString *const JDStatusBarStyleDefault; /// This style has a white background with a gray Helvetica label.
extern NSString *const JDStatusBarStyleDark;    /// This style has a nearly black background with a nearly white Helvetica label.

typedef NS_ENUM(NSInteger, JDStatusBarAnimationType) {
    JDStatusBarAnimationTypeNone, /// Notification won't animate
    JDStatusBarAnimationTypeMove, /// Notification will move in from the top, and move out again to the top
    JDStatusBarAnimationTypeFade  /// Notification will fade in and fade out
};

@class JDStatusBarStyle;

/**
 *  A block that is used to define the appearance of a notification.
 *  A JDStatusBarStyle instance defines the notification appeareance.
 *
 *  @param style The current default JDStatusBarStyle instance.
 *
 *  @return The modified JDStatusBarStyle instance.
 */
typedef JDStatusBarStyle*(^JDPrepareStyleBlock)(JDStatusBarStyle *style);

/**
 *  This class is a singletion which is used to present notifications 
 *  on top of the status bar. To present a notification, use one of the
 *  given class methods.
 */
@interface JDStatusBarNotification : UIView

#pragma mark Presentation

/**
 *  Show a notification. It won't hide automatically,
 *  you have to dimiss it on your own.
 *
 *  @param status The message to display
 *
 *  @return The presented notification view for further customization
 */
+ (UIView*)showWithStatus:(NSString *)status;

/**
 *  Show a notification with a specific style. It won't
 *  hide automatically, you have to dimiss it on your own.
 *
 *  @param status The message to display
 *  @param styleName The name of the style. You can use any JDStatusBarStyle, or a
 *  custom style, after you added one. If this is nil, the default style will be used.
 *
 *  @return The presented notification view for further customization
 */
+ (UIView*)showWithStatus:(NSString *)status
                styleName:(NSString*)styleName;

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
+ (UIView*)showWithStatus:(NSString *)status
             dismissAfter:(NSTimeInterval)timeInterval;

/**
 *  Same as showWithStatus:styleName:, but the notification
 *  will automatically dismiss after the given timeInterval.
 *
 *  @param status       The message to display
 *  @param timeInterval The duration, how long the notification
 *  is displayed. (Including the animation duration)
 *  @param styleName The name of the style. You can use any JDStatusBarStyle, or a
 *  custom style, after you added one. If this is nil, the default style will be used.
 *
 *  @return The presented notification view for further customization
 */
+ (UIView*)showWithStatus:(NSString *)status
             dismissAfter:(NSTimeInterval)timeInterval
                styleName:(NSString*)styleName;

#pragma mark Dismissal

/**
 *  Calls dismissAnimated: with animated set to YES
 */
+ (void)dismiss;

/**
 *  Dismisses any currently displayed notification immediately
 *
 *  @param animated If this is YES, the animation style used
 *  for presentation will also be used for the dismissal.
 */
+ (void)dismissAnimated:(BOOL)animated;

/**
 *  Same as dismissAnimated:, but you can specify a delay,
 *  so the notification wont be dismissed immediately
 *
 *  @param delay The delay, how long the notification should stay visible
 */
+ (void)dismissAfter:(NSTimeInterval)delay;

#pragma mark Styles

/**
 *  This changes the default style, which is always used
 *  when a method without styleName is used for presentation, or
 *  styleName is nil, or no style is found with this name.
 *
 *  @param prepareBlock A block, which has a JDStatusBarStyle instance as 
 *  parameter. This instance can be modified to suit your needs. You need
 *  to return the modified style again.
 */
+ (void)setDefaultStyle:(JDPrepareStyleBlock)prepareBlock;

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
+ (NSString*)addStyleNamed:(NSString*)identifier
                   prepare:(JDPrepareStyleBlock)prepareBlock;

#pragma mark progress & activity

/**
 *  Show the progress below the label.
 *
 *  @param progress Relative progress from 0.0 to 1.0
 */
+ (void)showProgress:(CGFloat)progress;

/**
 *  Shows an activity indicator in front of the notification text
 *
 *  @param show           Use this flag to show or hide the activity indicator
 *  @param indicatorStyle Sets the style of the activity indicator
 */
+ (void)showActivityIndicator:(BOOL)show
               indicatorStyle:(UIActivityIndicatorViewStyle)style;

#pragma mark state

+ (BOOL)isVisible;

@end

/**
 *  A Style defines the appeareance of a notification.
 */
@interface JDStatusBarStyle : NSObject <NSCopying>

/// The background color of the notification bar
@property (nonatomic, strong) UIColor *barColor;

/// The text color of the notification label
@property (nonatomic, strong) UIColor *textColor;

/// The text shadow of the notification label
@property (nonatomic, strong) NSShadow *textShadow;

/// The font of the notification label
@property (nonatomic, strong) UIFont *font;

/// The animation, that is used to present the notification
@property (nonatomic, assign) JDStatusBarAnimationType animationType;

#pragma mark progress bar

/// The background color of the progress bar (on top of the notification bar)
@property (nonatomic, strong) UIColor *progressBarColor;

/// The height of the progress bar. Default is 1.0
@property (nonatomic, assign) CGFloat progressBarHeight;

@end


