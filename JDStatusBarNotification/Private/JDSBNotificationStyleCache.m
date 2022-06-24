//
//

#import "JDSBNotificationStyleCache.h"

#import "JDStatusBarNotificationStyle.h"

@implementation JDSBNotificationStyleCache {
  JDStatusBarNotificationStyle *_defaultStyle;
  NSMutableDictionary *_userStyles;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _defaultStyle = [JDStatusBarNotificationStyle new];
    _userStyles = [NSMutableDictionary dictionary];
  }
  return self;
}

- (JDStatusBarNotificationStyle *)styleForName:(NSString *)styleName {
  return (_userStyles[styleName] ?: _defaultStyle);
}

- (JDStatusBarNotificationStyle *)styleForIncludedStyle:(JDStatusBarIncludedStyle)style {
  return includedStyle(style);
}

- (void)updateDefaultStyle:(NS_NOESCAPE JDStatusBarPrepareStyleBlock)prepareBlock {
  _defaultStyle = prepareBlock([_defaultStyle copy]);
}

- (NSString *)addStyleNamed:(NSString *)styleName
                    prepare:(NS_NOESCAPE JDStatusBarPrepareStyleBlock)prepareBlock {
  [_userStyles setObject:prepareBlock([_defaultStyle copy]) forKey:styleName];
  return styleName;
}

- (NSString *)addStyleNamed:(NSString*)styleName
               basedOnStyle:(JDStatusBarIncludedStyle)basedOnStyle
                    prepare:(NS_NOESCAPE JDStatusBarPrepareStyleBlock)prepareBlock {
  [_userStyles setObject:prepareBlock([includedStyle(basedOnStyle) copy]) forKey:styleName];
  return styleName;
}

static JDStatusBarNotificationStyle *includedStyle(JDStatusBarIncludedStyle style) {
  switch (style) {
    case JDStatusBarIncludedStyleDefaultStyle:
      return [JDStatusBarNotificationStyle new];

    case JDStatusBarIncludedStyleLight: {
      JDStatusBarNotificationStyle *style = [JDStatusBarNotificationStyle new];
      style.backgroundStyle.backgroundColor = [UIColor whiteColor];
      style.textStyle.textColor = [UIColor grayColor];
      style.systemStatusBarStyle = JDStatusBarSystemStyleDarkContent;
      return style;
    }

    case JDStatusBarIncludedStyleDark: {
      JDStatusBarNotificationStyle *style = [JDStatusBarNotificationStyle new];
      style.backgroundStyle.backgroundColor = [UIColor colorWithRed:0.050 green:0.078 blue:0.120 alpha:1.000];
      style.textStyle.textColor = [UIColor colorWithWhite:0.95 alpha:1.0];
      style.systemStatusBarStyle = JDStatusBarSystemStyleLightContent;
      return style;
    }

    case JDStatusBarIncludedStyleError: {
      JDStatusBarNotificationStyle *style = [JDStatusBarNotificationStyle new];
      style.backgroundStyle.backgroundColor = [UIColor colorWithRed:0.588 green:0.118 blue:0.000 alpha:1.000];
      style.textStyle.textColor = [UIColor whiteColor];
      style.subtitleStyle.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
      style.progressBarStyle.barColor = [UIColor redColor];
      return style;
    }

    case JDStatusBarIncludedStyleWarning: {
      JDStatusBarNotificationStyle *style = [JDStatusBarNotificationStyle new];
      style.backgroundStyle.backgroundColor = [UIColor colorWithRed:0.900 green:0.734 blue:0.034 alpha:1.000];
      style.textStyle.textColor = [UIColor darkGrayColor];
      style.subtitleStyle.textColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.75];
      style.progressBarStyle.barColor = style.textStyle.textColor;
      return style;
    }

    case JDStatusBarIncludedStyleSuccess: {
      JDStatusBarNotificationStyle *style = [JDStatusBarNotificationStyle new];
      style.backgroundStyle.backgroundColor = [UIColor colorWithRed:0.588 green:0.797 blue:0.000 alpha:1.000];
      style.textStyle.textColor = [UIColor whiteColor];
      style.subtitleStyle.textColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.2 alpha:1.0];
      style.progressBarStyle.barColor = [UIColor colorWithRed:0.106 green:0.594 blue:0.319 alpha:1.000];
      return style;
    }

    case JDStatusBarIncludedStyleMatrix: {
      JDStatusBarNotificationStyle *style = [JDStatusBarNotificationStyle new];
      style.backgroundStyle.backgroundColor = [UIColor blackColor];
      style.textStyle.textColor = [UIColor greenColor];
      style.textStyle.font = [UIFont fontWithName:@"Courier-Bold" size:14.0];
      style.subtitleStyle.textColor = [UIColor whiteColor];
      style.subtitleStyle.font = [UIFont fontWithName:@"Courier" size:12.0];
      style.progressBarStyle.barColor = [UIColor greenColor];
      style.systemStatusBarStyle = JDStatusBarSystemStyleLightContent;
      return style;
    }
  }
}

@end
