//
//  JDStatusBarStyle.h
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JDStatusBarPrepareStyleBlock.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString * JDStatusBarIncludedStyle NS_EXTENSIBLE_STRING_ENUM;

/// This style has a red background with a white Helvetica label.
extern JDStatusBarIncludedStyle const JDStatusBarIncludedStyleError;
/// This style has a yellow background with a gray Helvetica label.
extern JDStatusBarIncludedStyle const JDStatusBarIncludedStyleWarning;
/// This style has a green background with a white Helvetica label.
extern JDStatusBarIncludedStyle const JDStatusBarIncludedStyleSuccess;
/// This style has a black background with a green bold Courier label.
extern JDStatusBarIncludedStyle const JDStatusBarIncludedStyleMatrix;
/// This style has a white background with a gray Helvetica label.
extern JDStatusBarIncludedStyle const JDStatusBarIncludedStyleDefault;
/// This style has a nearly black background with a nearly white Helvetica label.
extern JDStatusBarIncludedStyle const JDStatusBarIncludedStyleDark;

typedef NS_ENUM(NSInteger, JDStatusBarAnimationType) {
  /// Notification won't animate
  JDStatusBarAnimationTypeNone,
  /// Notification will move in from the top, and move out again to the top
  JDStatusBarAnimationTypeMove,
  /// Notification will fall down from the top and bounce a little bit
  JDStatusBarAnimationTypeBounce,
  /// Notification will fade in and fade out
  JDStatusBarAnimationTypeFade,
};

typedef NS_ENUM(NSInteger, JDStatusBarProgressBarPosition) {
  /// progress bar will be at the bottom of the status bar
  JDStatusBarProgressBarPositionBottom,
  /// progress bar will be at the center of the status bar
  JDStatusBarProgressBarPositionCenter,
  /// progress bar will be at the top of the status bar
  JDStatusBarProgressBarPositionTop
};

typedef NS_ENUM(NSInteger, JDStatusBarSystemStyle) {
  /// Use current default
  JDStatusBarSystemStyleDefault,
  /// Force light status bar contents (UIStatusBarStyleLightContent)
  JDStatusBarSystemStyleLightContent,
  /// Force dark status bar contents (UIStatusBarStyleDarkContent)
  JDStatusBarSystemStyleDarkContent
};

@class JDStatusBarProgressBarStyle;

/**
 *  A Style defines the appeareance of a notification.
 */
@interface JDStatusBarStyle : NSObject <NSCopying>

/// The background color of the notification bar
@property (nonatomic, strong, nullable) UIColor *barColor;

/// The text color of the notification label
@property (nonatomic, strong, nullable) UIColor *textColor;

/// The text shadow of the notification label
@property (nonatomic, strong, nullable) NSShadow *textShadow;

/// The font of the notification label
@property (nonatomic, strong, nullable) UIFont *font;

/// A correction of the vertical label position in points. Default is 0.0
@property (nonatomic, assign) CGFloat textVerticalPositionAdjustment;

/// The UIStatusBarStyle, which should be used during presentation
@property (nonatomic, assign) JDStatusBarSystemStyle systemStatusBarStyle;

/// The animation, that is used to present the notification
@property (nonatomic, assign) JDStatusBarAnimationType animationType;

/// The styling of the progress bar
@property (nonatomic, strong) JDStatusBarProgressBarStyle *progressBarStyle;

/// Defines if the bar can be dismissed by the user or not (by swiping up)
@property (nonatomic, assign) BOOL canSwipeToDismiss;

@end

/**
 *  A Style defines the appeareance of a notification.
 */
@interface JDStatusBarProgressBarStyle : NSObject <NSCopying>

/// The background color of the progress bar (on top of the notification bar)
@property (nonatomic, strong, nullable) UIColor *barColor;

/// The height of the progress bar. Default is 1.0. The applied value will have a minimum of 0.5 and a maximum full status bar height.
@property (nonatomic, assign) CGFloat barHeight;

/// The position of the progress bar. Default is JDStatusBarProgressBarPositionBottom
@property (nonatomic, assign) JDStatusBarProgressBarPosition position;

/// The insets of the progress bar. Default is 0.0
@property (nonatomic, assign) CGFloat horizontalInsets;

/// The corner radius of the progress bar. Default is 0.0
@property (nonatomic, assign) CGFloat cornerRadius;

@end

NS_ASSUME_NONNULL_END
