//
//  JDStatusBarNotificationStyle.m
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "JDStatusBarNotificationStyle.h"

@implementation JDStatusBarNotificationTextStyle

- (instancetype)init {
  self = [super init];
  if (self) {
    _textColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
      switch (traitCollection.userInterfaceStyle) {
        case UIUserInterfaceStyleUnspecified:
        case UIUserInterfaceStyleLight:
          return [UIColor grayColor];
        case UIUserInterfaceStyleDark:
          return [UIColor colorWithWhite:0.95 alpha:1.0];
      }
    }];

    _font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    _shadowColor = nil;
    _shadowOffset = CGPointMake(1.0, 2.0);
    _textOffsetY = 0.0;
  }
  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  JDStatusBarNotificationTextStyle *style = [[[self class] allocWithZone:zone] init];
  style.textColor = self.textColor;
  style.font = self.font;
  style.shadowColor = self.shadowColor;
  style.shadowOffset = self.shadowOffset;
  style.textOffsetY = self.textOffsetY;
  return style;
}

- (CGSize)textShadowOffset {
  return CGSizeMake(_shadowOffset.x, _shadowOffset.y);
}

- (void)setTextShadowOffset:(CGSize)textShadowOffset {
  _shadowOffset = CGPointMake(textShadowOffset.width, textShadowOffset.height);
}

- (UIColor *)textShadowColor {
  return _shadowColor;
}

- (void)setTextShadowColor:(UIColor *)textShadowColor {
  _shadowColor = textShadowColor;
}

@end

@implementation JDStatusBarNotificationLeftViewStyle

- (instancetype)init {
  self = [super init];
  if (self) {
    _spacing = 5.0;
    _offset = CGPointZero;
    _tintColor = nil;
    _alignment = JDStatusBarNotificationLeftViewAlignmentCenterWithText;
  }
  return self;
}

- (CGFloat)offsetX {
  return _offset.x;
}

- (void)setOffsetX:(CGFloat)offsetX {
  _offset.x = offsetX;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  JDStatusBarNotificationLeftViewStyle *style = [[[self class] allocWithZone:zone] init];
  style.spacing = _spacing;
  style.offset = _offset;
  style.tintColor = _tintColor;
  style.alignment = _alignment;
  return style;
}

@end

@implementation JDStatusBarNotificationPillStyle

- (instancetype)init {
  self = [super init];
  if (self) {
    _height = 50.0;
    _topSpacing = 0.0;
    _minimumWidth = 200.0;
    _borderColor = nil;
    _borderWidth = 2.0;
    _shadowColor = nil;
    _shadowRadius = 4.0;
    _shadowOffsetXY = CGPointMake(0.0, 2.0);
  }
  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  JDStatusBarNotificationPillStyle *style = [[[self class] allocWithZone:zone] init];
  style.height = self.height;
  style.topSpacing = self.topSpacing;
  style.minimumWidth = self.minimumWidth;
  style.borderColor = self.borderColor;
  style.borderWidth = self.borderWidth;
  style.shadowColor = self.shadowColor;
  style.shadowRadius = self.shadowRadius;
  style.shadowOffsetXY = self.shadowOffsetXY;
  return style;
}

- (CGSize)shadowOffset {
  return CGSizeMake(_shadowOffsetXY.x, _shadowOffsetXY.y);
}

- (void)setShadowOffset:(CGSize)shadowOffset {
  _shadowOffsetXY = CGPointMake(shadowOffset.width, shadowOffset.height);
}

@end

@implementation JDStatusBarNotificationBackgroundStyle

- (instancetype)init {
  self = [super init];
  if (self) {
    _backgroundColor = [UIColor colorWithDynamicProvider:^UIColor *(UITraitCollection *traitCollection) {
      switch (traitCollection.userInterfaceStyle) {
        case UIUserInterfaceStyleUnspecified:
        case UIUserInterfaceStyleLight:
          return [UIColor whiteColor];
        case UIUserInterfaceStyleDark:
          return [UIColor colorWithRed:0.050 green:0.078 blue:0.120 alpha:1.000];
      }
    }];

    _backgroundType = JDStatusBarNotificationBackgroundTypePill;
    _pillStyle = [JDStatusBarNotificationPillStyle new];
  }
  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  JDStatusBarNotificationBackgroundStyle *style = [[[self class] allocWithZone:zone] init];
  style.backgroundColor = self.backgroundColor;
  style.backgroundType = self.backgroundType;
  style.pillStyle = [self.pillStyle copy];
  return style;
}

@end

@implementation JDStatusBarNotificationProgressBarStyle

- (instancetype)init {
  self = [super init];
  if (self) {
    _barColor = [UIColor greenColor];
    _barHeight = 2.0;
    _horizontalInsets = 20.0;
    _cornerRadius = 1.0;
    _position = JDStatusBarNotificationProgressBarPositionBottom;
    _offsetY = -5.0;
  }
  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  JDStatusBarNotificationProgressBarStyle *style = [[[self class] allocWithZone:zone] init];
  style.barColor = self.barColor;
  style.barHeight = self.barHeight;
  style.position = self.position;
  style.horizontalInsets = self.horizontalInsets;
  style.cornerRadius = self.cornerRadius;
  style.offsetY = self.offsetY;
  return style;
}

@end

@implementation JDStatusBarNotificationStyle

- (instancetype)init {
  self = [super init];
  if (self) {
    _textStyle = [JDStatusBarNotificationTextStyle new];

    _subtitleStyle = [JDStatusBarNotificationTextStyle new];
    _subtitleStyle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    _subtitleStyle.textColor = [_textStyle.textColor colorWithAlphaComponent:0.66];

    _backgroundStyle = [JDStatusBarNotificationBackgroundStyle new];
    _progressBarStyle = [JDStatusBarNotificationProgressBarStyle new];
    _leftViewStyle = [JDStatusBarNotificationLeftViewStyle new];

    _animationType = JDStatusBarNotificationAnimationTypeMove;
    _systemStatusBarStyle = JDStatusBarNotificationSystemBarStyleDefaultStyle;
    _canSwipeToDismiss = YES;
    _canTapToHold = YES;
    _canDismissDuringUserInteraction = NO;
  }
  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  JDStatusBarNotificationStyle *style = [[[self class] allocWithZone:zone] init];
  style.textStyle = [self.textStyle copy];
  style.subtitleStyle = [self.subtitleStyle copy];
  style.backgroundStyle = [self.backgroundStyle copy];
  style.progressBarStyle = [self.progressBarStyle copy];
  style.leftViewStyle = [self.leftViewStyle copy];

  style.animationType = self.animationType;
  style.systemStatusBarStyle = self.systemStatusBarStyle;
  style.canSwipeToDismiss = self.canSwipeToDismiss;
  style.canTapToHold = self.canTapToHold;
  style.canDismissDuringUserInteraction = self.canDismissDuringUserInteraction;

  return style;
}

@end
