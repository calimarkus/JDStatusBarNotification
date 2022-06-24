//
//  JDStatusBarNotificationStyle.h
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JDStatusBarPrepareStyleBlock.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JDStatusBarIncludedStyle) {
  /// A dynamic style matching the .light style in light mode and .dark in dark mode.
  JDStatusBarIncludedStyleDefaultStyle,
  /// A white background with a gray text.
  JDStatusBarIncludedStyleLight,
  /// A nearly black background with a nearly white text.
  JDStatusBarIncludedStyleDark,
  /// A green background with a white text.
  JDStatusBarIncludedStyleSuccess,
  /// A yellow background with a gray text.
  JDStatusBarIncludedStyleWarning,
  /// A red background with a white text.
  JDStatusBarIncludedStyleError,
  /// A black background with a green bold monospace text..
  JDStatusBarIncludedStyleMatrix,
} NS_SWIFT_NAME(IncludedStatusBarStyle);

typedef NS_ENUM(NSInteger, JDStatusBarBackgroundType) {
  /// The background covers the full display width and the full status bar & navbar height.
  JDStatusBarBackgroundTypeFullWidth,
  /// The background is a floating pill around the text.
  JDStatusBarBackgroundTypePill,
} NS_SWIFT_NAME(BarBackgroundType);

typedef NS_ENUM(NSInteger, JDStatusBarAnimationType) {
  /// Notification will move in from the top, and move out again to the top
  JDStatusBarAnimationTypeMove,
  /// Notification will fall down from the top and bounce a little bit
  JDStatusBarAnimationTypeBounce,
  /// Notification will fade in and fade out
  JDStatusBarAnimationTypeFade,
} NS_SWIFT_NAME(BarAnimationType);

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
  JDStatusBarSystemStyleDefaultStyle,
  /// Force light status bar contents (UIStatusBarStyleLightContent)
  JDStatusBarSystemStyleLightContent,
  /// Force dark status bar contents (UIStatusBarStyleDarkContent)
  JDStatusBarSystemStyleDarkContent
} NS_SWIFT_NAME(StatusBarSystemStyle);

typedef NS_ENUM(NSInteger, JDStatusBarLeftViewAlignment) {
  /// Always align left. Text is center aligned unlless it touches the left view. If it does touch the left view, the text turns left aligned too.
  JDStatusBarLeftViewAlignmentLeft,
  /// Center together with text. Text is left aligned.
  JDStatusBarLeftViewAlignmentCenterWithText,
} NS_SWIFT_NAME(BarLeftViewAlignment);

@class JDStatusBarBackgroundStyle;
@class JDStatusBarProgressBarStyle;
@class JDStatusBarLeftViewStyle;
@class JDStatusBarTextStyle;

/**
 *  A Style defines the appeareance of a notification.
 */
NS_SWIFT_NAME(StatusBarNotificationStyle)
@interface JDStatusBarNotificationStyle : NSObject <NSCopying>

/// The styling of the title label (Defaults: UIFontTextStyleFootnote, color: .gray and adjusts for dark mode)
///
/// The title's .textColor is also used for the activity indicator, unless an explicit leftViewStyle.tintColor is set.
/// The title's .textOffsetY affects both the title, the subtitle and the left view. And also the progressBar when using .center positioning.
@property (nonatomic, strong) JDStatusBarTextStyle *textStyle;

/// The styling of the subtitle label (Defaults: UIFontTextStyleCaption1, color: title color at 66% opacity)
///
/// The subtitle's .textOffsetY affects only the subtitle.
@property (nonatomic, strong) JDStatusBarTextStyle *subtitleStyle;

/// The styling of the background
@property (nonatomic, strong) JDStatusBarBackgroundStyle *backgroundStyle;

/// The styling of the progress bar
@property (nonatomic, strong) JDStatusBarProgressBarStyle *progressBarStyle;

/// The styling of the left view, if used. This also applies to the activity indicator.
@property (nonatomic, strong) JDStatusBarLeftViewStyle *leftViewStyle;

/// The animation for presentation & dismissal
@property (nonatomic, assign) JDStatusBarAnimationType animationType;

/// The UIStatusBarStyle, which should be used during presentation. If you use BarBackgroundType.pill, this is ignored. The default is .defaultStyle.
@property (nonatomic, assign) JDStatusBarSystemStyle systemStatusBarStyle;

/// Defines if the bar can be dismissed by the user swiping up. Default is true.
///
/// Under the hood this enables/disables the internal PanGestureRecognizer.
@property (nonatomic, assign) BOOL canSwipeToDismiss;

/// Defines if the bar can be touched to prevent a dismissal until the tap is released. Default is true.
///
/// Both .canTapToHold and .canDismissDuringUserInteraction has to be true to have tap-to-hold working.
/// You might want to disable .canTapToHold, if you are utilizing a custom view that wants to handle touches itself (e.g. a button).
/// Under the hood this enables/disables the internal LongPressGestureRecognizer.
@property (nonatomic, assign) BOOL canTapToHold;

/// Defines if the bar is allowed to be dismissed while the user touches or pans the view.
///
/// The default is false, meaning that a banner stays presented as long as a touch / pan is active.
/// Once the touch is released, the view will be dismised if a dismiss call was made during the interaction.
/// Any passed-in dismiss completion block will still be executed, once the actual dismissal happened.
@property (nonatomic, assign) BOOL canDismissDuringUserInteraction;

@end

/**
 *  Defines the appeareance of a left view, if set. It also applies to the activity indicator.
 */
NS_SWIFT_NAME(NotificationLeftViewStyle)
@interface JDStatusBarLeftViewStyle : NSObject <NSCopying>

/// The minimum distance between the left view and the text. Defaults to 5.0.
@property (nonatomic, assign) CGFloat spacing;

/// An optional offset to adjust the left views x position. Default 0.0.
@property (nonatomic, assign) CGFloat offsetX __deprecated_msg("deprecated, use .offset.x instead");

/// An optional offset to adjust the left views position. Default is CGPointZero.
@property (nonatomic, assign) CGPoint offset;

/// Sets the tint color of the left view. Default is nil.
///
/// This applies to the activity indicator, or a custom left view. The activity indicator
/// defaults to the title text color, if no tintColor is specified.
@property (nonatomic, strong, nullable) UIColor *tintColor;

/// The alignment of the left view. The default is .centerWithText
/// If no text is set, the left view is always centered.
@property (nonatomic, assign) JDStatusBarLeftViewAlignment alignment;

@end

/**
 *  Defines the appeareance of a text label.
 */
NS_SWIFT_NAME(NotificationTextStyle)
@interface JDStatusBarTextStyle : NSObject <NSCopying>

/// The color of the  label.
@property (nonatomic, strong, nullable) UIColor *textColor;

/// The font of the label.
@property (nonatomic, strong) UIFont *font;

/// The text shadow color, the default is nil, meaning no shadow.
@property (nonatomic, strong, nullable) UIColor *textShadowColor __deprecated_msg("deprecated, use .shadowColor instead");

/// The text shadow offset of the notification label. Default is (1, 2)
@property (nonatomic, assign) CGSize textShadowOffset __deprecated_msg("deprecated, use .shadowOffset instead");

/// The text shadow color, the default is nil, meaning no shadow.
@property (nonatomic, strong, nullable) UIColor *shadowColor;

/// The text shadow offset of the notification label. Default is (1, 2)
@property (nonatomic, assign) CGPoint shadowOffset;

/// Offsets the text label on the y-axis. Default is 0.0.
@property (nonatomic, assign) CGFloat textOffsetY;

@end

/**
 *  Defines the appeareance of the pill, when using BarBackgroundType.pill
 */
NS_SWIFT_NAME(BarPillStyle)
@interface JDStatusBarPillStyle : NSObject <NSCopying>

/// The height of the pill. Default is 50.0.
@property (nonatomic, assign) CGFloat height;

/// The spacing between the pill and the statusbar or top of the screen.. Default is 0.0.
@property (nonatomic, assign) CGFloat topSpacing;

/// The minimum with of the pill. Default is 200.0.
/// If this is lower than the pill height, the pill height is used as minimum width.
@property (nonatomic, assign) CGFloat minimumWidth;

/// The border color of the pill. The default is nil, meaning no border.
@property (nonatomic, strong, nullable) UIColor *borderColor;

/// The width of the pill border. The default is 2.0.
@property (nonatomic, assign) CGFloat borderWidth;

/// The shadow color of the pill shadow. The default is nil, meaning no shadow.
@property (nonatomic, strong, nullable) UIColor *shadowColor;

/// The shadow radius of the pill shadow. The default is 4.0.
@property (nonatomic, assign) CGFloat shadowRadius;

/// The shadow offset for the pill shadow. The default is (0, 2).
@property (nonatomic, assign) CGSize shadowOffset __deprecated_msg("deprecated, use .shadowOffsetXY instead");

/// The shadow offset for the pill shadow. The default is (0, 2).
@property (nonatomic, assign) CGPoint shadowOffsetXY;

@end

/**
 *  Defines the appeareance of the notification background.
 */
NS_SWIFT_NAME(NotificationBackgroundStyle)
@interface JDStatusBarBackgroundStyle : NSObject <NSCopying>

/// The background color of the notification bar
@property (nonatomic, strong, nullable) UIColor *backgroundColor;

/// The background type. Default is .pill
@property (nonatomic, assign) JDStatusBarBackgroundType backgroundType;

/// A style to modify the appearance of the pill, when using BarBackgroundType.pill.
@property (nonatomic, strong) JDStatusBarPillStyle *pillStyle;

@end

/**
 *  Defines the appeareance of the progress bar.
 */
NS_SWIFT_NAME(ProgressBarStyle)
@interface JDStatusBarProgressBarStyle : NSObject <NSCopying>

/// The background color of the progress bar (on top of the notification bar)
@property (nonatomic, strong, nullable) UIColor *barColor;

/// The height of the progress bar. Default is 2.0. The applied value will have a minimum of 0.5 and a maximum full status bar height.
@property (nonatomic, assign) CGFloat barHeight;

/// The position of the progress bar. Default is .bottom
@property (nonatomic, assign) JDStatusBarProgressBarPosition position;

/// The insets of the progress bar. Default is 20.0
@property (nonatomic, assign) CGFloat horizontalInsets;

/// Offsets the progress bar on the  y-axis. Default is -5.0.
@property (nonatomic, assign) CGFloat offsetY;

/// The corner radius of the progress bar. Default is 1.0
@property (nonatomic, assign) CGFloat cornerRadius;

@end

NS_ASSUME_NONNULL_END
