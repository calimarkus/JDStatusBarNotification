//
//

#import "JDStatusBarIncludedStyles.h"

#import "JDStatusBarStyle.h"

@implementation JDStatusBarIncludedStyles

+ (JDStatusBarStyle *)defaultStyle {
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

  return style;
}

+ (JDStatusBarStyle * _Nullable)defaultStyleWithName:(NSString *)styleName {
  // JDStatusBarStyleDefault
  if ([styleName isEqualToString:JDStatusBarStyleDefault]) {
    return [self defaultStyle];
  }

  // JDStatusBarStyleError
  else if ([styleName isEqualToString:JDStatusBarStyleError]) {
    JDStatusBarStyle *style = [self defaultStyle];
    style.barColor = [UIColor colorWithRed:0.588 green:0.118 blue:0.000 alpha:1.000];
    style.textColor = [UIColor whiteColor];
    style.progressBarStyle.barColor = [UIColor redColor];
    style.progressBarStyle.barHeight = 2.0;
    return style;
  }

  // JDStatusBarStyleWarning
  else if ([styleName isEqualToString:JDStatusBarStyleWarning]) {
    JDStatusBarStyle *style = [self defaultStyle];
    style.barColor = [UIColor colorWithRed:0.900 green:0.734 blue:0.034 alpha:1.000];
    style.textColor = [UIColor darkGrayColor];
    style.progressBarStyle.barColor = style.textColor;
    return style;
  }

  // JDStatusBarStyleSuccess
  else if ([styleName isEqualToString:JDStatusBarStyleSuccess]) {
    JDStatusBarStyle *style = [self defaultStyle];
    style.barColor = [UIColor colorWithRed:0.588 green:0.797 blue:0.000 alpha:1.000];
    style.textColor = [UIColor whiteColor];
    style.progressBarStyle.barColor = [UIColor colorWithRed:0.106 green:0.594 blue:0.319 alpha:1.000];
    style.progressBarStyle.barHeight = 1.0+1.0/[[UIScreen mainScreen] scale];
    return style;
  }

  // JDStatusBarStyleDark
  else if ([styleName isEqualToString:JDStatusBarStyleDark]) {
    JDStatusBarStyle *style = [self defaultStyle];
    style.barColor = [UIColor colorWithRed:0.050 green:0.078 blue:0.120 alpha:1.000];
    style.textColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    style.progressBarStyle.barHeight = 1.0+1.0/[[UIScreen mainScreen] scale];
    style.systemStatusBarStyle = JDStatusBarSystemStyleLightContent;
    return style;
  }

  // JDStatusBarStyleMatrix
  else if ([styleName isEqualToString:JDStatusBarStyleMatrix]) {
    JDStatusBarStyle *style = [self defaultStyle];
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
