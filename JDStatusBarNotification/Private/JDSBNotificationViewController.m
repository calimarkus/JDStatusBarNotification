//
//

#import "JDSBNotificationViewController.h"

#import "JDSBNotificationAnimator.h"
#import "JDStatusBarNotificationStyle.h"
#import "JDSBNotificationView.h"
#import "UIApplication+JDSB_MainWindow.h"

@interface JDSBNotificationViewController () <JDSBNotificationViewDelegate>
@end

@implementation JDSBNotificationViewController {
  BOOL _forceDismissalOnTouchesEnded;
  NSTimer *_dismissTimer;
  JDSBNotificationViewControllerCompletion _dismissCompletionBlock;
  JDSBNotificationAnimator *_animator;

  CGFloat _panInitialY;
  CGFloat _panMaxY;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _statusBarView = [JDSBNotificationView new];
    _statusBarView.delegate = self;
    [_statusBarView.panGestureRecognizer addTarget:self action:@selector(panGestureRecognized:)];
    [_statusBarView.longPressGestureRecognizer addTarget:self action:@selector(longPressGestureRecognized:)];

    _animator = [[JDSBNotificationAnimator alloc] initWithStatusBarView:_statusBarView];
  }
  return self;
}

- (void)loadView {
  [super loadView];

  self.view.backgroundColor = [UIColor clearColor];
  [self.view addSubview:_statusBarView];
}

#pragma mark - Presentation

- (JDSBNotificationView *)presentWithTitle:(NSString *)title
                             subtitle:(NSString *)subtitle
                                style:(JDStatusBarNotificationStyle *)style
                           completion:(JDSBNotificationViewControllerCompletion)completion {
  JDSBNotificationView *topBar = _statusBarView;

  // update status & style
  [topBar setTitle:title];
  [topBar setSubtitle:subtitle];
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

#pragma mark - JDSBNotificationViewDelegate

- (void)didUpdateStyle {
  [_delegate didUpdateStyle];
}

#pragma mark - Pan gesture

static BOOL canRubberBandForBackgroundType(JDStatusBarNotificationBackgroundType type) {
  switch (type) {
    case JDStatusBarNotificationBackgroundTypeFullWidth:
      return NO;
    case JDStatusBarNotificationBackgroundTypePill:
      return YES;
  }
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer {
  if (recognizer.isEnabled) {
    switch (recognizer.state) {
      case UIGestureRecognizerStatePossible:
        break;
      case UIGestureRecognizerStateBegan:
        [recognizer setTranslation:CGPointZero inView:_statusBarView];
        _panMaxY = 0.0;
        _panInitialY = [recognizer locationInView:_statusBarView].y;
        break;
      case UIGestureRecognizerStateChanged: {
        CGPoint translation = [recognizer translationInView:_statusBarView];
        _panMaxY = MAX(_panMaxY, translation.y);

        // rubber banding downwards + immediate upwards movement even after rubber banding
        BOOL canRubberBand = canRubberBandForBackgroundType(_statusBarView.style.backgroundStyle.backgroundType);
        CGFloat rubberBandingLimit = 4.0;
        CGFloat rubberBanding = (_panMaxY > 0 && canRubberBand
                                 ? rubberBandingLimit * (1 + log10(_panMaxY/rubberBandingLimit))
                                 : 0.0);
        CGFloat yPos = (translation.y <= _panMaxY
                        ? translation.y - _panMaxY + rubberBanding
                        : rubberBanding);
        _statusBarView.transform = CGAffineTransformMakeTranslation(0, yPos);
        break;
      }
      case UIGestureRecognizerStateEnded:
      case UIGestureRecognizerStateCancelled:
      case UIGestureRecognizerStateFailed: {
        CGFloat relativeMovement = (_statusBarView.transform.ty / _panInitialY);
        if (!_forceDismissalOnTouchesEnded && -relativeMovement < 0.25) {
          // animate back in place
          [UIView animateWithDuration:0.22 animations:^{
            self->_statusBarView.transform = CGAffineTransformIdentity;
          }];
        } else {
          // dismiss
          [self forceDismiss];
        }
      }
    }
  }
}

- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)recognizer {
  if (recognizer.isEnabled) {
    switch (recognizer.state)
      case UIGestureRecognizerStateEnded: {
        if (_forceDismissalOnTouchesEnded) {
          [self forceDismiss];
        }
        break;
      default:
        break;
    }
  }
}

#pragma mark - Dismissal

- (void)dismissAfterDelay:(NSTimeInterval)delay
             completion:(JDSBNotificationViewControllerCompletion)completion {
  [_dismissTimer invalidate];

  _dismissCompletionBlock = [completion copy];
  _dismissTimer = [NSTimer scheduledTimerWithTimeInterval:delay
                                                   target:self
                                                 selector:@selector(dismissTimerFired:)
                                                 userInfo:nil
                                                  repeats:NO];
}

- (void)dismissTimerFired:(NSTimer *)timer {
  JDSBNotificationViewControllerCompletion block = _dismissCompletionBlock;
  _dismissCompletionBlock = nil;
  [self dismissWithDuration:0.4 completion:block];
}

- (void)dismissWithDuration:(CGFloat)duration
                 completion:(JDSBNotificationViewControllerCompletion)completion {
  [_dismissTimer invalidate];
  _dismissTimer = nil;

  if ([self canDismiss]) {
    _statusBarView.panGestureRecognizer.enabled = NO;

    // animate out
    __weak __typeof(self) weakSelf = self;
    [_animator animateOutWithDuration:duration completion:^ {
      [weakSelf.delegate didDismissStatusBar];
      if (completion != nil) {
        completion();
      }
    }];
  } else {
    _dismissCompletionBlock = completion;
    _forceDismissalOnTouchesEnded = YES;
  }
}

- (void)forceDismiss {
  JDSBNotificationViewControllerCompletion block = _dismissCompletionBlock;
  _dismissCompletionBlock = nil;
  [self dismissWithDuration:0.25 completion:block];
}

- (BOOL)canDismiss {
  if (_statusBarView.style.canDismissDuringUserInteraction) {
    return YES; // allow dismissal during interaction
  }

  // prevent dismissal during interaction
  if (isGestureRecognizerActive(_statusBarView.longPressGestureRecognizer)
      || isGestureRecognizerActive(_statusBarView.panGestureRecognizer)) {
    return NO;
  }

  // allow otherwise
  return YES;
}

static BOOL isGestureRecognizerActive(UIGestureRecognizer *gestureRecognizer) {
  switch (gestureRecognizer.state) {
    case UIGestureRecognizerStateBegan:
    case UIGestureRecognizerStateChanged:
      return YES;
    default:
      return NO;
  }
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

static BOOL JDUIViewControllerBasedStatusBarAppearanceEnabled(void) {
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
    case JDStatusBarNotificationBackgroundTypeFullWidth:
      switch (_statusBarView.style.systemStatusBarStyle) {
        case JDStatusBarNotificationSystemBarStyleDefaultStyle:
          return [self defaultStatusBarStyle];
        case JDStatusBarNotificationSystemBarStyleLightContent:
          return UIStatusBarStyleLightContent;
        case JDStatusBarNotificationSystemBarStyleDarkContent:
          return UIStatusBarStyleDarkContent;
      }
    case JDStatusBarNotificationBackgroundTypePill:
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
