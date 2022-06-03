//
//

#import "JDStatusBarWindow.h"

#import "JDStatusBarNotificationViewController.h"
#import "JDStatusBarView.h"

@implementation JDStatusBarWindow

- (instancetype)initWithStyle:(JDStatusBarStyle *)style
                  windowScene:(UIWindowScene * _Nullable)windowScene {
  if (windowScene != nil) {
    self = [super initWithWindowScene:windowScene];
  } else {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
  }

  if (self) {
    _statusBarViewController = [[JDStatusBarNotificationViewController alloc] initWithStyle:style];
    self.rootViewController = _statusBarViewController;

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.windowLevel = UIWindowLevelStatusBar;
  }
  return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  UIView *topBar = _statusBarViewController.statusBarView;
  if (topBar != nil) {
    CGRect rect = [self convertRect:topBar.bounds fromView:topBar];
    if (topBar.userInteractionEnabled && CGRectContainsPoint(rect, point)) {
      return [topBar hitTest:point withEvent:event];
    }
  }
  return nil;
}

@end
