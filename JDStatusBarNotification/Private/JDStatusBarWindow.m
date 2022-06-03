//
//

#import "JDStatusBarWindow.h"

#import "JDStatusBarNotificationViewController.h"
#import "JDStatusBarView.h"
#import "UIApplication+MainWindow.h"
#import "JDStatusBarManagerHelper.h"

@interface JDStatusBarWindow () <JDStatusBarNotificationViewControllerDelegate>
@end

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
    _statusBarViewController.delegate = self;
    self.rootViewController = _statusBarViewController;

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.windowLevel = UIWindowLevelStatusBar;

    [self updateFramesForStatusBarFrame:JDStatusBarFrameForWindowScene(windowScene)];
  }
  return self;
}

#pragma mark - Sizing

- (void)updateFramesForStatusBarFrame:(CGRect)rect {
  // match main window transform & frame
  UIWindow *window = [[UIApplication sharedApplication] jdsb_mainApplicationWindowIgnoringWindow:self];
  self.transform = window.transform;
  self.frame = window.frame;

  // default to window width
  if (CGRectIsEmpty(rect)) {
    rect = CGRectMake(0, 0, window.frame.size.width, 0.0);
  }

  // update top bar frame
  CGFloat heightIncludingNavBar = rect.size.height + navBarHeight(window.windowScene);
  _statusBarViewController.statusBarView.frame = CGRectMake(0, 0, rect.size.width, heightIncludingNavBar);

  // relayout progress bar
  [_statusBarViewController.statusBarView setProgressBarPercentage:_statusBarViewController.statusBarView.progressBarPercentage];
}

static CGFloat navBarHeight(UIWindowScene *windowScene) {
  if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) &&
      UIInterfaceOrientationIsLandscape(JDStatusBarOrientationForWindowScene(windowScene))) {
    return 32.0;
  }
  return 44.0;
}

#pragma mark - JDStatusBarNotificationViewControllerDelegate

- (void)animationsForViewTransitionToSize:(CGSize)size {
  // update window & statusbar
  [self updateFramesForStatusBarFrame:CGRectMake(0, 0, size.width, JDStatusBarFrameForWindowScene(self.windowScene).size.height)];
}

- (void)didDismissStatusBar {
  [self.delegate didDismissStatusBar];
}

#pragma mark - HitTest

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
