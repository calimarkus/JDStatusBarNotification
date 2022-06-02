//
//  JDStatusBarStyle.m
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "JDStatusBarStyle.h"

NSString *const JDStatusBarStyleError   = @"JDStatusBarStyleError";
NSString *const JDStatusBarStyleWarning = @"JDStatusBarStyleWarning";
NSString *const JDStatusBarStyleSuccess = @"JDStatusBarStyleSuccess";
NSString *const JDStatusBarStyleMatrix  = @"JDStatusBarStyleMatrix";
NSString *const JDStatusBarStyleDefault = @"JDStatusBarStyleDefault";
NSString *const JDStatusBarStyleDark    = @"JDStatusBarStyleDark";

@implementation JDStatusBarProgressBarStyle

- (instancetype)copyWithZone:(NSZone *)zone {
  JDStatusBarProgressBarStyle *style = [[[self class] allocWithZone:zone] init];
  style.barColor = self.barColor;
  style.barHeight = self.barHeight;
  style.position = self.position;
  style.horizontalInsets = self.horizontalInsets;
  style.cornerRadius = self.cornerRadius;
  return style;
}

@end

@implementation JDStatusBarStyle

- (instancetype)copyWithZone:(NSZone *)zone {
  JDStatusBarStyle *style = [[[self class] allocWithZone:zone] init];
  style.barColor = self.barColor;
  style.textColor = self.textColor;
  style.textShadow = self.textShadow;
  style.font = self.font;
  style.textVerticalPositionAdjustment = self.textVerticalPositionAdjustment;
  style.systemStatusBarStyle = self.systemStatusBarStyle;
  style.animationType = self.animationType;
  style.progressBarStyle = [self.progressBarStyle copy];
  style.canSwipeToDismiss = self.canSwipeToDismiss;
  return style;
}

@end
