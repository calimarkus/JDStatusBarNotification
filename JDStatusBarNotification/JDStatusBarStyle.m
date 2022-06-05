//
//  JDStatusBarStyle.m
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "JDStatusBarStyle.h"

@implementation JDStatusBarProgressBarStyle

- (instancetype)init {
  self = [super init];
  if (self) {
    _barColor = [UIColor greenColor];
    _barHeight = 1.0;
    _position = JDStatusBarProgressBarPositionBottom;
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
    _backgroundColor = [UIColor whiteColor];
    _textColor = [UIColor grayColor];
    _font = [UIFont systemFontOfSize:12.0];
    _animationType = JDStatusBarAnimationTypeMove;
    _backgroundType = JDStatusBarBackgroundTypeClassic;
    _systemStatusBarStyle = JDStatusBarSystemStyleDarkContent;
    _progressBarStyle = [JDStatusBarProgressBarStyle new];
    _canSwipeToDismiss = YES;
  }
  return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
  JDStatusBarStyle *style = [[[self class] allocWithZone:zone] init];
  style.backgroundColor = self.backgroundColor;
  style.textColor = self.textColor;
  style.font = self.font;
  style.textShadowColor = self.textShadowColor;
  style.textShadowOffset = self.textShadowOffset;
  style.textOffsetY = self.textOffsetY;
  style.animationType = self.animationType;
  style.backgroundType = self.backgroundType;
  style.systemStatusBarStyle = self.systemStatusBarStyle;
  style.progressBarStyle = [self.progressBarStyle copy];
  style.canSwipeToDismiss = self.canSwipeToDismiss;
  return style;
}

@end
