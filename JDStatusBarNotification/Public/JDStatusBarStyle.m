//
//  JDStatusBarStyle.m
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "JDStatusBarStyle.h"

@implementation JDStatusBarTextStyle

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
    _textShadowColor = nil;
    _textShadowOffset = CGSizeMake(1.0, 2.0);
    _textOffsetY = 0.0;
  }
  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  JDStatusBarTextStyle *style = [[[self class] allocWithZone:zone] init];
  style.textColor = self.textColor;
  style.font = self.font;
  style.textShadowColor = self.textShadowColor;
  style.textShadowOffset = self.textShadowOffset;
  style.textOffsetY = self.textOffsetY;
  return style;
}

@end

@implementation JDStatusBarLeftViewStyle

- (instancetype)init {
  self = [super init];
  if (self) {
    _spacing = 5.0;
    _offset = CGSizeZero;
    _alignment = JDStatusBarLeftViewAlignmentCenterWithText;
  }
  return self;
}

- (CGFloat)offsetX {
  return _offset.width;
}

- (void)setOffsetX:(CGFloat)offsetX {
  _offset.width = offsetX;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  JDStatusBarLeftViewStyle *style = [[[self class] allocWithZone:zone] init];
  style.spacing = _spacing;
  style.offset = _offset;
  style.alignment = _alignment;
  return style;
}

@end

@implementation JDStatusBarPillStyle

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
    _shadowOffset = CGSizeMake(0.0, 2.0);
  }
  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  JDStatusBarPillStyle *style = [[[self class] allocWithZone:zone] init];
  style.height = self.height;
  style.topSpacing = self.topSpacing;
  style.minimumWidth = self.minimumWidth;
  style.borderColor = self.borderColor;
  style.borderWidth = self.borderWidth;
  style.shadowColor = self.shadowColor;
  style.shadowRadius = self.shadowRadius;
  style.shadowOffset = self.shadowOffset;
  return style;
}

@end

@implementation JDStatusBarBackgroundStyle

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

    _backgroundType = JDStatusBarBackgroundTypePill;
    _pillStyle = [JDStatusBarPillStyle new];
  }
  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  JDStatusBarBackgroundStyle *style = [[[self class] allocWithZone:zone] init];
  style.backgroundColor = self.backgroundColor;
  style.backgroundType = self.backgroundType;
  style.pillStyle = [self.pillStyle copy];
  return style;
}

@end

@implementation JDStatusBarProgressBarStyle

- (instancetype)init {
  self = [super init];
  if (self) {
    _barColor = [UIColor greenColor];
    _barHeight = 2.0;
    _horizontalInsets = 20.0;
    _cornerRadius = 1.0;
    _position = JDStatusBarProgressBarPositionBottom;
    _offsetY = -5.0;
  }
  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  JDStatusBarProgressBarStyle *style = [[[self class] allocWithZone:zone] init];
  style.barColor = self.barColor;
  style.barHeight = self.barHeight;
  style.position = self.position;
  style.horizontalInsets = self.horizontalInsets;
  style.cornerRadius = self.cornerRadius;
  style.offsetY = self.offsetY;
  return style;
}

@end

@implementation JDStatusBarStyle

- (instancetype)init {
  self = [super init];
  if (self) {
    _textStyle = [JDStatusBarTextStyle new];

    _subtitleStyle = [JDStatusBarTextStyle new];
    _subtitleStyle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    _subtitleStyle.textColor = [_textStyle.textColor colorWithAlphaComponent:0.66];

    _backgroundStyle = [JDStatusBarBackgroundStyle new];
    _progressBarStyle = [JDStatusBarProgressBarStyle new];
    _leftViewStyle = [JDStatusBarLeftViewStyle new];

    _animationType = JDStatusBarAnimationTypeMove;
    _systemStatusBarStyle = JDStatusBarSystemStyleDefaultStyle;
    _canSwipeToDismiss = YES;
    _canDismissDuringUserInteraction = NO;
  }
  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  JDStatusBarStyle *style = [[[self class] allocWithZone:zone] init];
  style.textStyle = [self.textStyle copy];
  style.subtitleStyle = [self.subtitleStyle copy];
  style.backgroundStyle = [self.backgroundStyle copy];
  style.progressBarStyle = [self.progressBarStyle copy];
  style.leftViewStyle = [self.leftViewStyle copy];

  style.animationType = self.animationType;
  style.systemStatusBarStyle = self.systemStatusBarStyle;
  style.canSwipeToDismiss = self.canSwipeToDismiss;
  style.canDismissDuringUserInteraction = self.canDismissDuringUserInteraction;

  return style;
}

@end
