//
//

#import "JDSBNotificationWindow.h"

#import "JDSBNotificationViewController.h"
#import "JDSBNotificationView.h"
#import "JDStatusBarNotificationStyle.h"
#import "UIApplication+JDSB_MainWindow.h"
#import "JDSystemStatusBarHelpers.h"

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
  JDSBNotificationView *statusBarView = _statusBarViewController.statusBarView;
  CGFloat heightIncludingNavBar = rect.size.height + contentHeight(window.windowScene, statusBarView.style, rect);
  statusBarView.transform = CGAffineTransformIdentity;
  statusBarView.frame = CGRectMake(0, 0, rect.size.width, heightIncludingNavBar);

  // relayout progress bar
  [statusBarView setProgressBarPercentage:_statusBarViewController.statusBarView.progressBarPercentage];
}

static CGFloat contentHeight(UIWindowScene *windowScene, JDStatusBarNotificationStyle *style, CGRect statusBarRect) {
  switch (style.backgroundStyle.backgroundType) {
    case JDStatusBarNotificationBackgroundTypeFullWidth: {
      if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) &&
          UIInterfaceOrientationIsLandscape(JDStatusBarOrientationForWindowScene(windowScene))) {
        return 32.0; // match navbar height
      } else {
        return 44.0; // match navbar height
      }
    }
    case JDStatusBarNotificationBackgroundTypePill: {
      CGFloat notchAdjustment = 0.0;
      if (statusBarRect.size.height >= 54.0) {
        notchAdjustment = 0.0; // for the dynamic island, utilize the default positioning
      } else if (statusBarRect.size.height > 20.0) {
        notchAdjustment = -7.0; // this matches the positioning of a similar system notification
      } else {
        notchAdjustment = 3.0; // for no-notch devices, default to a minimum spacing
      }
      return style.backgroundStyle.pillStyle.height + style.backgroundStyle.pillStyle.topSpacing + notchAdjustment;
    }
  }
}

#pragma mark - JDSBNotificationViewControllerDelegate

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
