//
//  JDStatusBarNotificationStyle.h
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JDStatusBarNotificationIncludedStyle) {
  /// A dynamic style matching the `JDStatusBarNotificationIncludedStyleLight` style in light mode and `JDStatusBarNotificationIncludedStyleDark` in dark mode.
  JDStatusBarNotificationIncludedStyleDefaultStyle,
  /// A white background with a gray text.
  JDStatusBarNotificationIncludedStyleLight,
  /// A nearly black background with a nearly white text.
  JDStatusBarNotificationIncludedStyleDark,
  /// A green background with a white text.
  JDStatusBarNotificationIncludedStyleSuccess,
  /// A yellow background with a gray text.
  JDStatusBarNotificationIncludedStyleWarning,
  /// A red background with a white text.
  JDStatusBarNotificationIncludedStyleError,
  /// A black background with a green bold monospace text..
  JDStatusBarNotificationIncludedStyleMatrix,
} NS_SWIFT_NAME(IncludedStatusBarNotificationStyle);

typedef NS_ENUM(NSInteger, JDStatusBarNotificationBackgroundType) {
  /// The background covers the full display width and the full status bar & navbar height.
  JDStatusBarNotificationBackgroundTypeFullWidth,
  /// The background is a floating pill around the text.
  JDStatusBarNotificationBackgroundTypePill,
} NS_SWIFT_NAME(StatusBarNotificationBackgroundType);

typedef NS_ENUM(NSInteger, JDStatusBarNotificationAnimationType) {
  /// Notification will move in from the top, and move out again to the top
  JDStatusBarNotificationAnimationTypeMove,
  /// Notification will fall down from the top and bounce a little bit
  JDStatusBarNotificationAnimationTypeBounce,
  /// Notification will fade in and fade out
  JDStatusBarNotificationAnimationTypeFade,
} NS_SWIFT_NAME(StatusBarNotificationAnimationType);

typedef NS_ENUM(NSInteger, JDStatusBarNotificationProgressBarPosition) {
  /// progress bar will be at the bottom of the status bar
  JDStatusBarNotificationProgressBarPositionBottom,
  /// progress bar will be at the center of the status bar
  JDStatusBarNotificationProgressBarPositionCenter,
  /// progress bar will be at the top of the status bar
  JDStatusBarNotificationProgressBarPositionTop
} NS_SWIFT_NAME(StatusBarNotificationProgressBarPosition);

typedef NS_ENUM(NSInteger, JDStatusBarNotificationSystemBarStyle) {
  /// Match the current viewController / window
  JDStatusBarNotificationSystemBarStyleDefaultStyle,
  /// Force light status bar contents (UIStatusBarStyleLightContent)
  JDStatusBarNotificationSystemBarStyleLightContent,
  /// Force dark status bar contents (UIStatusBarStyleDarkContent)
  JDStatusBarNotificationSystemBarStyleDarkContent
} NS_SWIFT_NAME(StatusBarNotificationSystemBarStyle);

typedef NS_ENUM(NSInteger, JDStatusBarNotificationLeftViewAlignment) {
  /// Always align left. Text is center aligned unlless it touches the left view. If it does touch the left view, the text turns left aligned too.
  JDStatusBarNotificationLeftViewAlignmentLeft,
  /// Center together with text. Text is left aligned.
  JDStatusBarNotificationLeftViewAlignmentCenterWithText,
} NS_SWIFT_NAME(StatusBarNotificationLeftViewAlignment);

@class JDStatusBarNotificationBackgroundStyle;
@class JDStatusBarNotificationProgressBarStyle;
@class JDStatusBarNotificationLeftViewStyle;
@class JDStatusBarNotificationTextStyle;

/// A Style defines the appeareance of a notification.
NS_SWIFT_NAME(StatusBarNotificationStyle)
@interface JDStatusBarNotificationStyle : NSObject <NSCopying>

/// Defines the appeareance of the title label.
///
/// Defaults: `UIFontTextStyleFootnote`, color: `.gray` and adjusts for dark mode.
/// The title's `textColor` is also used for the activity indicator, unless an explicit `leftViewStyle.tintColor` is set.
/// The title's `textOffsetY` affects both the title, the subtitle and the left view. And also the progressBar when using `.center` positioning.
@property (nonatomic, strong) JDStatusBarNotificationTextStyle *textStyle;

/// Defines the appeareance of the subtitle label.
///
/// Defaults: `UIFontTextStyleCaption1`, color: The title color at 66% opacity.
///
/// The subtitle's .textOffsetY affects only the subtitle.
@property (nonatomic, strong) JDStatusBarNotificationTextStyle *subtitleStyle;

/// Defines the appeareance of the notification background.
@property (nonatomic, strong) JDStatusBarNotificationBackgroundStyle *backgroundStyle;

/// Defines the appeareance of the progress bar.
@property (nonatomic, strong) JDStatusBarNotificationProgressBarStyle *progressBarStyle;

/// Defines the appeareance of a left view, if set. It also applies to the activity indicator.
@property (nonatomic, strong) JDStatusBarNotificationLeftViewStyle *leftViewStyle;

/// Defines the animation type used during presentation and dismissal of the notification.
@property (nonatomic, assign) JDStatusBarNotificationAnimationType animationType;

/// Defines which `UIStatusBarStyle` should be used during presentation.
///
/// If you use `BackgroundType.pill`, this is ignored.
/// The default is `.defaultStyle`.
@property (nonatomic, assign) JDStatusBarNotificationSystemBarStyle systemStatusBarStyle;

/// Defines if the bar can be dismissed by the user swiping up. Default is `true`.
///
/// Under the hood this enables/disables the internal PanGestureRecognizer.
@property (nonatomic, assign) BOOL canSwipeToDismiss;

/// Defines if the bar can be touched to prevent a dismissal until the tap is released. Default is `true`.
///
/// If .canTapToHold is true and .canDismissDuringUserInteraction is false, the user can tap the
/// notification to prevent it from being dismissed until the tap is released. If you are utilizing a custom
/// view and need custom touch handling (e.g. for a button), you should set this to false.
///
/// Under the hood this enables/disables the internal LongPressGestureRecognizer.
@property (nonatomic, assign) BOOL canTapToHold;

/// Defines if the bar is allowed to be dismissed while the user touches or pans the view.
///
/// The default is `false`, meaning that a notification stays presented as long as a touch or pan is active.
/// Once the touch is released, the view will be dismised (if a dismiss call was made during the interaction).
/// Any passed-in dismiss completion block will still be executed, once the actual dismissal happened.
@property (nonatomic, assign) BOOL canDismissDuringUserInteraction;

@end

/// Defines the appeareance of a left view, if set. It also applies to the activity indicator.
NS_SWIFT_NAME(StatusBarNotificationLeftViewStyle)
@interface JDStatusBarNotificationLeftViewStyle : NSObject <NSCopying>

/// The minimum distance between the left view and the text. Defaults to 5.0.
@property (nonatomic, assign) CGFloat spacing;

/// An optional offset to adjust the left views x position. Default 0.0.
@property (nonatomic, assign) CGFloat offsetX __deprecated_msg("deprecated, use .offset.x instead");

/// An optional offset to adjust the left views position. Default is `CGPointZero`.
@property (nonatomic, assign) CGPoint offset;

/// Sets the tint color of the left view. Default is `nil`.
///
/// This applies to the activity indicator, or a custom left view. The activity indicator
/// defaults to the title text color, if no tintColor is specified.
@property (nonatomic, strong, nullable) UIColor *tintColor;

/// The alignment of the left view. The default is `.centerWithText`
/// If no title or subtitle is set, the left view is always fully centered.
@property (nonatomic, assign) JDStatusBarNotificationLeftViewAlignment alignment;

@end

/// Defines the appeareance of a text label.
NS_SWIFT_NAME(StatusBarNotificationTextStyle)
@interface JDStatusBarNotificationTextStyle : NSObject <NSCopying>

/// The color of the  label.
@property (nonatomic, strong, nullable) UIColor *textColor;

/// The font of the label.
@property (nonatomic, strong) UIFont *font;

/// The text shadow color, the default is `nil`, meaning no shadow.
@property (nonatomic, strong, nullable) UIColor *textShadowColor __deprecated_msg("deprecated, use .shadowColor instead");

/// The text shadow offset of the notification label. Default is `(1, 2)`
@property (nonatomic, assign) CGSize textShadowOffset __deprecated_msg("deprecated, use .shadowOffset instead");

/// The text shadow color, the default is `nil`, meaning no shadow.
@property (nonatomic, strong, nullable) UIColor *shadowColor;

/// The text shadow offset of the notification label. Default is `(1, 2)`
@property (nonatomic, assign) CGPoint shadowOffset;

/// Offsets the text label on the y-axis. Default is `0.0`.
@property (nonatomic, assign) CGFloat textOffsetY;

@end

/// Defines the appeareance of the pill, when using `BarBackgroundType.pill`
NS_SWIFT_NAME(StatusBarNotificationPillStyle)
@interface JDStatusBarNotificationPillStyle : NSObject <NSCopying>

/// The height of the pill. Default is `50.0`.
@property (nonatomic, assign) CGFloat height;

/// The spacing between the pill and the statusbar or top of the screen.. Default is `0.0`.
@property (nonatomic, assign) CGFloat topSpacing;

/// The minimum with of the pill. Default is `200.0`.
/// If this is lower than the pill height, the pill height is used as minimum width.
@property (nonatomic, assign) CGFloat minimumWidth;

/// The border color of the pill. The default is `nil`, meaning no border.
@property (nonatomic, strong, nullable) UIColor *borderColor;

/// The width of the pill border. The default is `2.0`.
@property (nonatomic, assign) CGFloat borderWidth;

/// The shadow color of the pill shadow. The default is `nil`, meaning no shadow.
@property (nonatomic, strong, nullable) UIColor *shadowColor;

/// The shadow radius of the pill shadow. The default is `4.0`.
@property (nonatomic, assign) CGFloat shadowRadius;

/// The shadow offset for the pill shadow. The default is `(0, 2)`.
@property (nonatomic, assign) CGSize shadowOffset __deprecated_msg("deprecated, use .shadowOffsetXY instead");

/// The shadow offset for the pill shadow. The default is `(0, 2)`.
@property (nonatomic, assign) CGPoint shadowOffsetXY;

@end

/// Defines the appeareance of the notification background.
NS_SWIFT_NAME(StatusBarNotificationBackgroundStyle)
@interface JDStatusBarNotificationBackgroundStyle : NSObject <NSCopying>

/// The background color of the notification bar
@property (nonatomic, strong, nullable) UIColor *backgroundColor;

/// The background type. Default is `.pill`
@property (nonatomic, assign) JDStatusBarNotificationBackgroundType backgroundType;

/// Defines the appeareance of the pill, when using `BarBackgroundType.pill`
@property (nonatomic, strong) JDStatusBarNotificationPillStyle *pillStyle;

@end

/// Defines the appeareance of the progress bar.
NS_SWIFT_NAME(StatusBarNotificationProgressBarStyle)
@interface JDStatusBarNotificationProgressBarStyle : NSObject <NSCopying>

/// The background color of the progress bar (on top of the notification bar)
@property (nonatomic, strong, nullable) UIColor *barColor;

/// The height of the progress bar. Default is `2.0`. The applied minimum is 0.5 and the maximum equals the full height of the notification.
@property (nonatomic, assign) CGFloat barHeight;

/// The position of the progress bar. Default is `.bottom`
@property (nonatomic, assign) JDStatusBarNotificationProgressBarPosition position;

/// The insets of the progress bar. Default is `20.0`
@property (nonatomic, assign) CGFloat horizontalInsets;

/// Offsets the progress bar on the  y-axis. Default is `-5.0`.
@property (nonatomic, assign) CGFloat offsetY;

/// The corner radius of the progress bar. Default is `1.0`
@property (nonatomic, assign) CGFloat cornerRadius;

@end

NS_ASSUME_NONNULL_END
