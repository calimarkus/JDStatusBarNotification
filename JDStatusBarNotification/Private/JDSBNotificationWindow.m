//
//

#import "JDSBNotificationWindow.h"

#import "JDSBNotificationViewController.h"
#import "JDSBNotificationView.h"
#import "JDStatusBarNotificationStyle.h"
#import "UIApplication+JDSB_MainWindow.h"

@interface JDSBNotificationWindow () <JDSBNotificationViewControllerDelegate>
@end

@implementation JDSBNotificationWindow

- (instancetype)initWithStyle:(JDStatusBarNotificationStyle *)style
                  windowScene:(UIWindowScene * _Nullable)windowScene {
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
    _statusBarViewController = [JDSBNotificationViewController new];
    _statusBarViewController.delegate = self;
    self.rootViewController = _statusBarViewController;

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.windowLevel = UIWindowLevelStatusBar;
  }
  return self;
}

#pragma mark - Sizing

- (void)relayoutWindowAndStatusBarView {
  // match main window transform & frame
  UIWindow *window = [[UIApplication sharedApplication] jdsb_mainApplicationWindowIgnoringWindow:self];
  self.transform = window.transform;
  self.frame = window.frame;

  // resize statusBarView
  JDSBNotificationView *const statusBarView = _statusBarViewController.statusBarView;
  const CGFloat safeAreaInset = self.safeAreaInsets.top;
  const CGFloat heightIncludingNavBar = safeAreaInset + contentHeight(statusBarView.style, safeAreaInset);
  statusBarView.transform = CGAffineTransformIdentity;
  statusBarView.frame = CGRectMake(0, 0, window.frame.size.width, heightIncludingNavBar);

  // relayout progress bar
  [statusBarView setProgressBarPercentage:_statusBarViewController.statusBarView.progressBarPercentage];
}

static CGFloat contentHeight(JDStatusBarNotificationStyle *style, CGFloat safeAreaInset) {
  switch (style.backgroundStyle.backgroundType) {
    case JDStatusBarNotificationBackgroundTypeFullWidth: {
      if (safeAreaInset >= 54.0) {
        return 38.66; // for dynamic island devices, this ensures the navbar separator stays visible
      } else {
        return 44.0; // default navbar height
      }
    }
    case JDStatusBarNotificationBackgroundTypePill: {
      CGFloat notchAdjustment = 0.0;
      if (safeAreaInset >= 54.0) {
        notchAdjustment = 0.0; // for the dynamic island, utilize the default positioning
      } else if (safeAreaInset > 20.0) {
        notchAdjustment = -7.0; // this matches the positioning of a similar system notification
      } else {
        notchAdjustment = 3.0; // for no-notch devices, default to a minimum spacing
      }
      return style.backgroundStyle.pillStyle.height + style.backgroundStyle.pillStyle.topSpacing + notchAdjustment;
    }
  }
}

#pragma mark - JDSBNotificationViewControllerDelegate

- (void)didDismissStatusBar {
  [self.delegate didDismissStatusBar];
}

- (void)didUpdateStyle {
  [self relayoutWindowAndStatusBarView];
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
