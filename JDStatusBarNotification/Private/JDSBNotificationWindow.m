//
//

#import "JDSBNotificationWindow.h"

#import "JDSBNotificationViewController.h"
#import "JDSBNotificationView.h"
#import "JDStatusBarNotificationStyle.h"
#import "GeneratedObjcSymbolsFromSwift.h"

@interface JDSBNotificationWindow () <JDSBNotificationViewControllerDelegate>
@end

@implementation JDSBNotificationWindow {
  __weak id<JDSBNotificationWindowDelegate> _delegate;
}

- (instancetype)initWithWindowScene:(UIWindowScene * _Nullable)windowScene
                           delegate:(id<JDSBNotificationWindowDelegate>)delegate {
  // attempt to infer window scene
  if (windowScene == nil) {
    windowScene = [[UIApplication sharedApplication] jdsb_mainApplicationWindowIgnoringWindow:nil].windowScene;
  }

  if (windowScene != nil) {
    self = [super initWithWindowScene:windowScene];
  } else {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
  }

  if (self) {
    _delegate = delegate;
    _statusBarViewController = [JDSBNotificationViewController new];
    _statusBarViewController.delegate = self;
    _statusBarViewController.jdsb_window = self;
    self.rootViewController = _statusBarViewController;

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.windowLevel = UIWindowLevelStatusBar;
  }
  return self;
}

#pragma mark - JDSBNotificationViewControllerDelegate

- (void)didDismissStatusBar {
  [_delegate didDismissStatusBar];
}

#pragma mark - HitTest

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  UIView *topBar = _statusBarViewController.statusBarView;
  if (topBar != nil && topBar.userInteractionEnabled) {
    return [topBar hitTest:[self convertPoint:point toView:topBar] withEvent:event];
  }
  return nil;
}

@end
