//
//  JDStatusBarStyle.h
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JDStatusBarPrepareStyleBlock.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JDStatusBarIncludedStyle) {
  /// This style has a red background with a white Helvetica label.
  JDStatusBarIncludedStyleError,
  /// This style has a yellow background with a gray Helvetica label.
  JDStatusBarIncludedStyleWarning,
  /// This style has a green background with a white Helvetica label.
  JDStatusBarIncludedStyleSuccess,
  /// This style has a black background with a green bold Courier label.
  JDStatusBarIncludedStyleMatrix,
  /// This style has a white background with a gray Helvetica label.
  JDStatusBarIncludedStyleDefault,
  /// This style has a nearly black background with a nearly white Helvetica label.
  JDStatusBarIncludedStyleDark,
} NS_SWIFT_NAME(IncludedStatusBarStyle);

typedef NS_ENUM(NSInteger, JDStatusBarBackgroundType) {
  /// The background covers the full status bar & navbar area.
  JDStatusBarBackgroundTypeClassic,
  /// The background is a floating pill around the text.
  JDStatusBarBackgroundTypePill,
} NS_SWIFT_NAME(BarBackgroundType);

typedef NS_ENUM(NSInteger, JDStatusBarAnimationType) {
  /// Notification won't animate
  JDStatusBarAnimationTypeNone,
  /// Notification will move in from the top, and move out again to the top
  JDStatusBarAnimationTypeMove,
  /// Notification will fall down from the top and bounce a little bit
  JDStatusBarAnimationTypeBounce,
  /// Notification will fade in and fade out
  JDStatusBarAnimationTypeFade,
} NS_SWIFT_NAME(AnimationType);

typedef NS_ENUM(NSInteger, JDStatusBarProgressBarPosition) {
  /// progress bar will be at the bottom of the status bar
  JDStatusBarProgressBarPositionBottom,
  /// progress bar will be at the center of the status bar
  JDStatusBarProgressBarPositionCenter,
  /// progress bar will be at the top of the status bar
  JDStatusBarProgressBarPositionTop
} NS_SWIFT_NAME(ProgressBarPosition);

typedef NS_ENUM(NSInteger, JDStatusBarSystemStyle) {
  /// Match the current viewController / window
  JDStatusBarSystemStyleDefault,
  /// Force light status bar contents (UIStatusBarStyleLightContent)
  JDStatusBarSystemStyleLightContent,
  /// Force dark status bar contents (UIStatusBarStyleDarkContent)
  JDStatusBarSystemStyleDarkContent
} NS_SWIFT_NAME(StatusBarSystemStyle);

@class JDStatusBarBackgroundStyle;
@class JDStatusBarProgressBarStyle;
@class JDStatusBarTextStyle;

/**
 *  A Style defines the appeareance of a notification.
 */
NS_SWIFT_NAME(StatusBarStyle)
@interface JDStatusBarStyle : NSObject <NSCopying>

/// The styling of the text
@property (nonatomic, strong) JDStatusBarTextStyle *textStyle;

/// The styling of the background
@property (nonatomic, strong) JDStatusBarBackgroundStyle *backgroundStyle;

/// The styling of the progress bar
@property (nonatomic, strong) JDStatusBarProgressBarStyle *progressBarStyle;

/// The animation for presentation & dismissal
@property (nonatomic, assign) JDStatusBarAnimationType animationType;

/// The UIStatusBarStyle, which should be used during presentation. If you use JDStatusBarBackgroundTypePill, this is ignored.
@property (nonatomic, assign) JDStatusBarSystemStyle systemStatusBarStyle;

/// Defines if the bar can be dismissed by the user or not (by swiping up)
@property (nonatomic, assign) BOOL canSwipeToDismiss;

@end

/**
 *  A Style defines the appeareance of a notification.
 */
NS_SWIFT_NAME(NotificationTextStyle)
@interface JDStatusBarTextStyle : NSObject <NSCopying>

/// The text color of the notification label
@property (nonatomic, strong, nullable) UIColor *textColor;

/// The font of the notification label, the default is UIFontTextStyleFootnote.
@property (nonatomic, strong) UIFont *font;

/// The text shadow color, the default is nil, meaning no shadow.
@property (nonatomic, strong, nullable) UIColor *textShadowColor;

/// The text shadow offset of the notification label.
@property (nonatomic, assign) CGSize textShadowOffset;

/// Offsets the text label on the y-axis. Default is 0.0.
@property (nonatomic, assign) CGFloat textOffsetY;

@end

/**
 *  A Style defines the appeareance of a notification.
 */
NS_SWIFT_NAME(NotificationBackgroundStyle)
@interface JDStatusBarBackgroundStyle : NSObject <NSCopying>

/// The background color of the notification bar
@property (nonatomic, strong, nullable) UIColor *backgroundColor;

/// The background type
@property (nonatomic, assign) JDStatusBarBackgroundType backgroundType;

@end

/**
 *  A Style defines the appeareance of a notification.
 */
NS_SWIFT_NAME(ProgressBarStyle)
@interface JDStatusBarProgressBarStyle : NSObject <NSCopying>

/// The background color of the progress bar (on top of the notification bar)
@property (nonatomic, strong, nullable) UIColor *barColor;

/// The height of the progress bar. Default is 1.0. The applied value will have a minimum of 0.5 and a maximum full status bar height.
@property (nonatomic, assign) CGFloat barHeight;

/// The position of the progress bar. Default is JDStatusBarProgressBarPositionBottom
@property (nonatomic, assign) JDStatusBarProgressBarPosition position;

/// The insets of the progress bar. Default is 0.0
@property (nonatomic, assign) CGFloat horizontalInsets;

/// Offsets the progress bar on the  y-axis. Default is 0.0.
@property (nonatomic, assign) CGFloat offsetY;

/// The corner radius of the progress bar. Default is 0.0
@property (nonatomic, assign) CGFloat cornerRadius;

@end

NS_ASSUME_NONNULL_END
