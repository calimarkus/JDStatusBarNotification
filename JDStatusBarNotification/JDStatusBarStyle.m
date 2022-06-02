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

+ (NSArray *)allDefaultStyleIdentifier {
  return @[JDStatusBarStyleError, JDStatusBarStyleWarning,
           JDStatusBarStyleSuccess, JDStatusBarStyleMatrix,
           JDStatusBarStyleDark];
}

+ (JDStatusBarStyle *)defaultStyleWithName:(NSString *)styleName {
  // setup default style
  JDStatusBarStyle *style = [[JDStatusBarStyle alloc] init];
  style.barColor = [UIColor whiteColor];
  style.textColor = [UIColor grayColor];
  style.font = [UIFont systemFontOfSize:12.0];
  style.systemStatusBarStyle = JDStatusBarSystemStyleDarkContent;
  style.animationType = JDStatusBarAnimationTypeMove;
  style.canSwipeToDismiss = YES;

  JDStatusBarProgressBarStyle *progressBarStyle = [[JDStatusBarProgressBarStyle alloc] init];
  progressBarStyle.barColor = [UIColor greenColor];
  progressBarStyle.barHeight = 1.0;
  progressBarStyle.position = JDStatusBarProgressBarPositionBottom;
  style.progressBarStyle = progressBarStyle;
  
  // JDStatusBarStyleDefault
  if ([styleName isEqualToString:JDStatusBarStyleDefault]) {
    return style;
  }
  
  // JDStatusBarStyleError
  else if ([styleName isEqualToString:JDStatusBarStyleError]) {
    style.barColor = [UIColor colorWithRed:0.588 green:0.118 blue:0.000 alpha:1.000];
    style.textColor = [UIColor whiteColor];
    style.progressBarStyle.barColor = [UIColor redColor];
    style.progressBarStyle.barHeight = 2.0;
    return style;
  }
  
  // JDStatusBarStyleWarning
  else if ([styleName isEqualToString:JDStatusBarStyleWarning]) {
    style.barColor = [UIColor colorWithRed:0.900 green:0.734 blue:0.034 alpha:1.000];
    style.textColor = [UIColor darkGrayColor];
    style.progressBarStyle.barColor = style.textColor;
    return style;
  }
  
  // JDStatusBarStyleSuccess
  else if ([styleName isEqualToString:JDStatusBarStyleSuccess]) {
    style.barColor = [UIColor colorWithRed:0.588 green:0.797 blue:0.000 alpha:1.000];
    style.textColor = [UIColor whiteColor];
    style.progressBarStyle.barColor = [UIColor colorWithRed:0.106 green:0.594 blue:0.319 alpha:1.000];
    style.progressBarStyle.barHeight = 1.0+1.0/[[UIScreen mainScreen] scale];
    return style;
  }
  
  // JDStatusBarStyleDark
  else if ([styleName isEqualToString:JDStatusBarStyleDark]) {
    style.barColor = [UIColor colorWithRed:0.050 green:0.078 blue:0.120 alpha:1.000];
    style.textColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    style.progressBarStyle.barHeight = 1.0+1.0/[[UIScreen mainScreen] scale];
    style.systemStatusBarStyle = JDStatusBarSystemStyleLightContent;
    return style;
  }
  
  // JDStatusBarStyleMatrix
  else if ([styleName isEqualToString:JDStatusBarStyleMatrix]) {
    style.barColor = [UIColor blackColor];
    style.textColor = [UIColor greenColor];
    style.font = [UIFont fontWithName:@"Courier-Bold" size:14.0];
    style.progressBarStyle.barColor = [UIColor greenColor];
    style.progressBarStyle.barHeight = 2.0;
    style.systemStatusBarStyle = JDStatusBarSystemStyleLightContent;
    return style;
  }
  
  return nil;
}

@end
