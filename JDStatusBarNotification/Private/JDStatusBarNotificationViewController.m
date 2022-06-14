//
//

#import "JDStatusBarNotificationViewController.h"

#import "JDStatusBarAnimator.h"
#import "JDStatusBarStyle.h"
#import "JDStatusBarView.h"
#import "UIApplication+JDSB_MainWindow.h"

@interface JDStatusBarNotificationViewController () <JDStatusBarViewDelegate>
@end

@implementation JDStatusBarNotificationViewController {
  NSTimer *_dismissTimer;
  JDStatusBarNotificationViewControllerCompletion _dismissCompletionBlock;
  JDStatusBarAnimator *_animator;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _statusBarView = [JDStatusBarView new];
    _statusBarView.delegate = self;

    _animator = [[JDStatusBarAnimator alloc] initWithStatusBarView:_statusBarView];
  }
  return self;
}

- (void)loadView {
  [super loadView];

  self.view.backgroundColor = [UIColor clearColor];
  [self.view addSubview:_statusBarView];
}

#pragma mark - Presentation

- (JDStatusBarView *)presentWithText:(NSString *)text
                               style:(JDStatusBarStyle *)style
                          completion:(JDStatusBarNotificationViewControllerCompletion)completion {
  JDStatusBarView *topBar = _statusBarView;

  // update status & style
  [topBar setText:text];
  [topBar setStyle:style];

  // reset progress & activity
  [topBar setProgressBarPercentage:0.0];
  [topBar setDisplaysActivityIndicator:NO];

  // reset dismiss timer & completion
  [_dismissTimer invalidate];
  _dismissTimer = nil;
  _dismissCompletionBlock = nil;

  // animate in
  [_animator animateInWithDuration:0.4 completion:completion];

  return topBar;
}

#pragma mark - JDStatusBarViewDelegate

- (void)statusBarViewDidPanToDismiss {
  [self dismissWithDuration:0.25 completion:nil];
}

- (void)didUpdateStyle {
  [_delegate didUpdateStyle];
}

#pragma mark - Dismissal

- (void)dismissAfterDelay:(NSTimeInterval)delay
             completion:(JDStatusBarNotificationViewControllerCompletion)completion {
  [_dismissTimer invalidate];

  _dismissCompletionBlock = [completion copy];
  _dismissTimer = [NSTimer scheduledTimerWithTimeInterval:delay
                                                   target:self
                                                 selector:@selector(dismissTimerFired:)
                                                 userInfo:nil
                                                  repeats:NO];
}

- (void)dismissTimerFired:(NSTimer *)timer {
  JDStatusBarNotificationViewControllerCompletion block = _dismissCompletionBlock;
  _dismissCompletionBlock = nil;
  [self dismissWithDuration:0.4 completion:block];
}

- (void)dismissWithDuration:(CGFloat)duration
                 completion:(JDStatusBarNotificationViewControllerCompletion)completion {
  [_dismissTimer invalidate];
  _dismissTimer = nil;

  // animate out
  __weak __typeof(self) weakSelf = self;
  [_animator animateOutWithDuration:duration completion:^ {
    [weakSelf.delegate didDismissStatusBar];
    if (completion != nil) {
      completion();
    }
  }];
}

#pragma mark - Rotation handling

- (BOOL)shouldAutorotate {
  return [[[UIApplication sharedApplication] jdsb_mainControllerIgnoringViewController:self] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return [[[UIApplication sharedApplication] jdsb_mainControllerIgnoringViewController:self] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
  return [[[UIApplication sharedApplication] jdsb_mainControllerIgnoringViewController:self] preferredInterfaceOrientationForPresentation];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

  [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    [self.delegate animationsForViewTransitionToSize:size];
  } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
    //
  }];
}

#pragma mark - System StatusBar Management

static BOOL JDUIViewControllerBasedStatusBarAppearanceEnabled() {
  static BOOL enabled = YES;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    NSNumber *value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIViewControllerBasedStatusBarAppearance"];
    if (value != nil) {
      enabled = [value boolValue];
    }
  });

  return enabled;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  switch (_statusBarView.style.backgroundStyle.backgroundType) {
    case JDStatusBarBackgroundTypeFullWidth:
      switch (_statusBarView.style.systemStatusBarStyle) {
        case JDStatusBarSystemStyleDefaultStyle:
          return [self defaultStatusBarStyle];
        case JDStatusBarSystemStyleLightContent:
          return UIStatusBarStyleLightContent;
        case JDStatusBarSystemStyleDarkContent:
          return UIStatusBarStyleDarkContent;
      }
    case JDStatusBarBackgroundTypePill:
      // the pills should not change the system status bar
      return [self defaultStatusBarStyle];
  }
}

- (UIStatusBarStyle)defaultStatusBarStyle {
  if(JDUIViewControllerBasedStatusBarAppearanceEnabled()) {
    return [[[UIApplication sharedApplication] jdsb_mainControllerIgnoringViewController:self] preferredStatusBarStyle];
  }

  return [super preferredStatusBarStyle];
}

- (BOOL)prefersStatusBarHidden {
  if(JDUIViewControllerBasedStatusBarAppearanceEnabled()) {
    return [[[UIApplication sharedApplication] jdsb_mainControllerIgnoringViewController:self] prefersStatusBarHidden];
  }
  return [super prefersStatusBarHidden];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
  return UIStatusBarAnimationFade;
}

@end
