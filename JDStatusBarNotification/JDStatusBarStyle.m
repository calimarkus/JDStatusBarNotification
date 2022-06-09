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
    _textColor = [UIColor grayColor];
    _font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
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

@implementation JDStatusBarPillStyle

- (instancetype)init {
  self = [super init];
  if (self) {
    _height = 36.0;
    _topSpacing = 6.0;
    _minimumWidth = 160.0;
    _borderColor = nil;
    _borderWidth = 2.0;
    _shadowColor = nil;
    _shadowRadius = 4.0;
    _shadowOffset = CGSizeMake(0, 2);
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
    _backgroundColor = [UIColor whiteColor];
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
    _offsetY = -3.0;
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
    _backgroundStyle = [JDStatusBarBackgroundStyle new];
    _animationType = JDStatusBarAnimationTypeMove;
    _systemStatusBarStyle = JDStatusBarSystemStyleDarkContent;
    _progressBarStyle = [JDStatusBarProgressBarStyle new];
    _canSwipeToDismiss = YES;
  }
  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  JDStatusBarStyle *style = [[[self class] allocWithZone:zone] init];
  style.textStyle = [self.textStyle copy];
  style.backgroundStyle = [self.backgroundStyle copy];
  style.animationType = self.animationType;
  style.systemStatusBarStyle = self.systemStatusBarStyle;
  style.progressBarStyle = [self.progressBarStyle copy];
  style.canSwipeToDismiss = self.canSwipeToDismiss;
  return style;
}

@end
