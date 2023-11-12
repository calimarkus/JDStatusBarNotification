//
//

#import "JDSBNotificationViewController.h"

#import "JDSBNotificationAnimator.h"
#import "JDStatusBarNotificationStyle.h"
#import "JDSBNotificationView.h"
#import "GeneratedObjcSymbolsFromSwift.h"

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
    [_statusBarView.panGestureRecognizer addTarget:self action:@selector(_panGestureRecognized:)];
    [_statusBarView.longPressGestureRecognizer addTarget:self action:@selector(_longPressGestureRecognized:)];

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

- (JDSBNotificationView *)presentWithStyle:(JDStatusBarNotificationStyle *)style
                                completion:(JDSBNotificationViewControllerCompletion)completion {
  JDSBNotificationView *topBar = _statusBarView;

  // reset text
  [topBar setTitle:nil];
  [topBar setSubtitle:nil];

  // reset progress & activity
  [topBar setProgressBarPercentage:0.0];
  [topBar setDisplaysActivityIndicator:NO];

  // set style
  [topBar setStyle:style];

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
  [self _relayoutWindowAndStatusBarView];
}

#pragma mark - Layouting

- (void)_relayoutWindowAndStatusBarView {
  UIWindow *jdsb_window = self.jdsb_window;

  // match main window transform & frame
  UIWindow *window = [[UIApplication sharedApplication] jdsb_mainApplicationWindowIgnoringWindow:jdsb_window];
  jdsb_window.transform = window.transform;
  jdsb_window.frame = window.frame;

  // resize statusBarView
  JDSBNotificationView *const statusBarView = self.statusBarView;
  const CGFloat safeAreaInset = jdsb_window.safeAreaInsets.top;
  const CGFloat heightIncludingNavBar = safeAreaInset + contentHeight(statusBarView.style, safeAreaInset);
  statusBarView.transform = CGAffineTransformIdentity;
  statusBarView.frame = CGRectMake(0, 0, window.frame.size.width, heightIncludingNavBar);

  // relayout progress bar
  [statusBarView setProgressBarPercentage:statusBarView.progressBarPercentage];
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

#pragma mark - Pan gesture

static BOOL canRubberBandForBackgroundType(JDStatusBarNotificationBackgroundType type) {
  switch (type) {
    case JDStatusBarNotificationBackgroundTypeFullWidth:
      return NO;
    case JDStatusBarNotificationBackgroundTypePill:
      return YES;
  }
}

- (void)_panGestureRecognized:(UIPanGestureRecognizer *)recognizer {
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
          [self _forceDismiss];
        }
      }
    }
  }
}

- (void)_longPressGestureRecognized:(UILongPressGestureRecognizer *)recognizer {
  if (recognizer.isEnabled) {
    switch (recognizer.state)
      case UIGestureRecognizerStateEnded: {
        if (_forceDismissalOnTouchesEnded) {
          [self _forceDismiss];
        }
        break;
      default:
        break;
    }
  }
}

#pragma mark - Dismissal

- (void)dismissWithDuration:(CGFloat)duration
                 afterDelay:(NSTimeInterval)delay
                 completion:(JDSBNotificationViewControllerCompletion)completion {
  [_dismissTimer invalidate];

  if (delay == 0.0) {
    [self _dismissWithDuration:duration completion:completion];
    return;
  }

  _dismissCompletionBlock = [completion copy];
  _dismissTimer = [NSTimer scheduledTimerWithTimeInterval:delay
                                                   target:self
                                                 selector:@selector(_dismissTimerFired:)
                                                 userInfo:@{@"duration": @(duration)}
                                                  repeats:NO];
}

- (void)_dismissTimerFired:(NSTimer *)timer {
  JDSBNotificationViewControllerCompletion block = _dismissCompletionBlock;
  _dismissCompletionBlock = nil;

  NSNumber *duration = timer.userInfo[@"duration"];
  [self _dismissWithDuration:[duration doubleValue] completion:block];
}

- (void)_dismissWithDuration:(CGFloat)duration
                  completion:(JDSBNotificationViewControllerCompletion)completion {
  [_dismissTimer invalidate];
  _dismissTimer = nil;

  if ([self _canDismiss]) {
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

- (void)_forceDismiss {
  JDSBNotificationViewControllerCompletion block = _dismissCompletionBlock;
  _dismissCompletionBlock = nil;
  [self _dismissWithDuration:0.25 completion:block];
}

- (BOOL)_canDismiss {
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
    [self _relayoutWindowAndStatusBarView];
  } completion:nil];
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
