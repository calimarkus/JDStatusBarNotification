//
//

#import "JDStatusBarWindow.h"

#import "JDStatusBarNotificationViewController.h"
#import "JDStatusBarView.h"
#import "JDStatusBarStyle.h"
#import "UIApplication+JDSB_MainWindow.h"
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
    _statusBarViewController = [JDStatusBarNotificationViewController new];
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
  JDStatusBarView *statusBarView = _statusBarViewController.statusBarView;
  CGFloat heightIncludingNavBar = rect.size.height + contentHeight(window.windowScene, statusBarView.style);
  statusBarView.transform = CGAffineTransformIdentity;
  statusBarView.frame = CGRectMake(0, 0, rect.size.width, heightIncludingNavBar);

  // relayout progress bar
  [statusBarView setProgressBarPercentage:_statusBarViewController.statusBarView.progressBarPercentage];
}

static CGFloat contentHeight(UIWindowScene *windowScene, JDStatusBarStyle *style) {
  switch (style.backgroundStyle.backgroundType) {
    case JDStatusBarBackgroundTypeFullWidth: {
      if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) &&
          UIInterfaceOrientationIsLandscape(JDStatusBarOrientationForWindowScene(windowScene))) {
        return 32.0; // match navbar height
      } else {
        return 44.0; // match navbar height
      }
    }
    case JDStatusBarBackgroundTypePill:
      return style.backgroundStyle.pillStyle.height + style.backgroundStyle.pillStyle.topSpacing;
  }
}

#pragma mark - JDStatusBarNotificationViewControllerDelegate

- (void)animationsForViewTransitionToSize:(CGSize)size {
  // update window & statusbar
  [self updateFramesForStatusBarFrame:CGRectMake(0, 0, size.width, JDStatusBarFrameForWindowScene(self.windowScene).size.height)];
}

- (void)didDismissStatusBar {
  [self.delegate didDismissStatusBar];
}

- (void)didUpdateStyle {
  [self updateFramesForStatusBarFrame:JDStatusBarFrameForWindowScene(self.windowScene)];
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
