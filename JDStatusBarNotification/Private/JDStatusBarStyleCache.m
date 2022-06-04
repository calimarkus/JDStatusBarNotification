//
//

#import "JDStatusBarStyleCache.h"

#import "JDStatusBarStyle.h"

@implementation JDStatusBarStyleCache {
  JDStatusBarStyle *_defaultStyle;
  NSMutableDictionary *_userStyles;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _defaultStyle = [JDStatusBarStyle new];
    _userStyles = [NSMutableDictionary dictionary];
  }
  return self;
}

- (JDStatusBarStyle *)styleForName:(NSString *)styleName {
  return (_userStyles[styleName] ?: _defaultStyle);
}

- (JDStatusBarStyle *)styleForIncludedStyle:(JDStatusBarIncludedStyle)style {
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

static JDStatusBarStyle *includedStyle(JDStatusBarIncludedStyle style) {
  switch (style) {
    case JDStatusBarIncludedStyleDefault:
      return [JDStatusBarStyle new];

    case JDStatusBarIncludedStyleError: {
      JDStatusBarStyle *style = [JDStatusBarStyle new];
      style.barColor = [UIColor colorWithRed:0.588 green:0.118 blue:0.000 alpha:1.000];
      style.textColor = [UIColor whiteColor];
      style.progressBarStyle.barColor = [UIColor redColor];
      style.progressBarStyle.barHeight = 2.0;
      return style;
    }

    case JDStatusBarIncludedStyleWarning: {
      JDStatusBarStyle *style = [JDStatusBarStyle new];
      style.barColor = [UIColor colorWithRed:0.900 green:0.734 blue:0.034 alpha:1.000];
      style.textColor = [UIColor darkGrayColor];
      style.progressBarStyle.barColor = style.textColor;
      return style;
    }

    case JDStatusBarIncludedStyleSuccess: {
      JDStatusBarStyle *style = [JDStatusBarStyle new];
      style.barColor = [UIColor colorWithRed:0.588 green:0.797 blue:0.000 alpha:1.000];
      style.textColor = [UIColor whiteColor];
      style.progressBarStyle.barColor = [UIColor colorWithRed:0.106 green:0.594 blue:0.319 alpha:1.000];
      style.progressBarStyle.barHeight = 1.0+1.0/[[UIScreen mainScreen] scale];
      return style;
    }

    case JDStatusBarIncludedStyleMatrix: {
      JDStatusBarStyle *style = [JDStatusBarStyle new];
      style.barColor = [UIColor blackColor];
      style.textColor = [UIColor greenColor];
      style.font = [UIFont fontWithName:@"Courier-Bold" size:14.0];
      style.progressBarStyle.barColor = [UIColor greenColor];
      style.progressBarStyle.barHeight = 2.0;
      style.systemStatusBarStyle = JDStatusBarSystemStyleLightContent;
      return style;
    }

    case JDStatusBarIncludedStyleDark: {
      JDStatusBarStyle *style = [JDStatusBarStyle new];
      style.barColor = [UIColor colorWithRed:0.050 green:0.078 blue:0.120 alpha:1.000];
      style.textColor = [UIColor colorWithWhite:0.95 alpha:1.0];
      style.progressBarStyle.barHeight = 1.0+1.0/[[UIScreen mainScreen] scale];
      style.systemStatusBarStyle = JDStatusBarSystemStyleLightContent;
      return style;
    }
  }
}

@end
