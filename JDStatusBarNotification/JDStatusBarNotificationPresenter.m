//
//  JDStatusBarNotificationPresenter.m
//
//  Based on KGStatusBar by Kevin Gibbon
//
//  Created by Markus Emrich on 10/28/13.
//  Copyright 2013 Markus Emrich. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "JDStatusBarNotificationPresenter.h"

#import "JDStatusBarStyle.h"
#import "JDStatusBarView.h"
#import "JDStatusBarWindow.h"
#import "JDStatusBarLayoutMarginHelper.h"
#import "JDStatusBarManagerHelper.h"
#import "UIApplication+MainWindow.h"
#import "JDStatusBarNotificationViewController.h"

@interface JDStatusBarStyle (Hidden)
+ (NSArray *)allDefaultStyleIdentifier;
+ (JDStatusBarStyle *)defaultStyleWithName:(NSString *)styleName;
@end

@interface JDStatusBarNotificationPresenter () <CAAnimationDelegate, JDStatusBarNotificationViewControllerDelegate>
@end

@implementation JDStatusBarNotificationPresenter {
  UIWindowScene *_windowScene;
  UIWindow *_overlayWindow;
  JDStatusBarNotificationViewController *_statusBarViewController;
  UIView *_progressView;
  JDStatusBarView *_topBar;
  
  NSTimer *_dismissTimer;
  CGFloat _progress;
  
  JDStatusBarStyle *_activeStyle;
  JDStatusBarStyle *_defaultStyle;
  NSMutableDictionary *_userStyles;
}

#pragma mark - Singleton

+ (instancetype)sharedPresenter {
  static dispatch_once_t once;
  static JDStatusBarNotificationPresenter *sharedInstance;
  dispatch_once(&once, ^ {
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

#pragma mark - Implementation

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setupDefaultStyles];
  }
  return self;
}

#pragma mark - Window Scene

- (void)setWindowScene:(UIWindowScene *)windowScene {
  _windowScene = windowScene;
}

#pragma mark - Custom styles

- (void)setupDefaultStyles {
  _defaultStyle = [JDStatusBarStyle defaultStyleWithName:JDStatusBarStyleDefault];
  
  _userStyles = [NSMutableDictionary dictionary];
  for (NSString *styleName in [JDStatusBarStyle allDefaultStyleIdentifier]) {
    [_userStyles setObject:[JDStatusBarStyle defaultStyleWithName:styleName] forKey:styleName];
  }
}

- (void)updateDefaultStyle:(JDStatusBarPrepareStyleBlock)prepareBlock {
  NSAssert(prepareBlock != nil, @"No prepareBlock provided");
  _defaultStyle = prepareBlock([_defaultStyle copy]);
}

- (NSString*)addStyleNamed:(NSString*)identifier
                   prepare:(JDStatusBarPrepareStyleBlock)prepareBlock {
  NSAssert(identifier != nil, @"No identifier provided");
  NSAssert(prepareBlock != nil, @"No prepareBlock provided");
  
  JDStatusBarStyle *style = [_defaultStyle copy];
  [_userStyles setObject:prepareBlock(style) forKey:identifier];
  return identifier;
}

#pragma mark - Presentation

- (JDStatusBarView *)showWithStatus:(NSString *)status {
  return [self showWithStatus:status dismissAfterDelay:0.0 styleName:nil];
}

- (JDStatusBarView *)showWithStatus:(NSString *)status
                          styleName:(NSString * _Nullable)styleName {
  return [self showWithStatus:status dismissAfterDelay:0.0 styleName:styleName];
}

- (JDStatusBarView *)showWithStatus:(NSString *)status
                  dismissAfterDelay:(NSTimeInterval)timeInterval {
  return [self showWithStatus:status dismissAfterDelay:timeInterval styleName:nil];
}

- (JDStatusBarView *)showWithStatus:(NSString *)status
                  dismissAfterDelay:(NSTimeInterval)timeInterval
                          styleName:(NSString * _Nullable)styleName {
  JDStatusBarStyle *style = nil;
  if (styleName != nil) {
    style = _userStyles[styleName];
  }
  
  if (style == nil) style = _defaultStyle;
  JDStatusBarView *view = [self showWithStatus:status style:style];
  if (timeInterval > 0.0) {
    [self dismissAfterDelay:timeInterval];
  }
  return view;
}

- (JDStatusBarView *)showWithStatus:(NSString *)status
                              style:(JDStatusBarStyle *)style {
  [self createWindowAndViewIfNeededWithStyle:style];
  [_topBar resetSubviewsIfNeeded];

  // prepare for new style
  if (style != _activeStyle) {
    _activeStyle = style;
    if (_activeStyle.animationType == JDStatusBarAnimationTypeFade) {
      _topBar.alpha = 0.0;
      _topBar.transform = CGAffineTransformIdentity;
    } else {
      _topBar.alpha = 1.0;
      _topBar.transform = CGAffineTransformMakeTranslation(0, -_topBar.frame.size.height);
    }
  }
  
  // Force update the TopBar frame if the height is 0
  if (_topBar.frame.size.height == 0) {
    [self updateContentFrame:JDStatusBarFrameForWindowScene(_windowScene)];
  }
  
  // cancel previous dismissing & remove animations
  [[NSRunLoop currentRunLoop] cancelPerformSelector:@selector(dismiss:) target:self argument:nil];
  [_topBar.layer removeAllAnimations];
  
  // create & show window
  [_overlayWindow setHidden:NO];
  
  // update status & style
  _statusBarViewController.statusBarSystemStyle = style.systemStatusBarStyle;
  [_topBar setStatus:status];
  [_topBar setStyle:style];
  
  // reset progress & activity
  [self showProgressBarWithPercentage:0.0];
  [self showActivityIndicator:NO];
  
  // animate in
  BOOL animationsEnabled = (style.animationType != JDStatusBarAnimationTypeNone);
  if (animationsEnabled && style.animationType == JDStatusBarAnimationTypeBounce) {
    [self animateInWithBounceAnimation];
  } else {
    [UIView animateWithDuration:(animationsEnabled ? 0.4 : 0.0) animations:^{
      self->_topBar.alpha = 1.0;
      self->_topBar.transform = CGAffineTransformIdentity;
    }];
  }
  
  return _topBar;
}

#pragma mark - Dismissal

static NSString *const kJDStatusBarDismissCompletionBlockKey = @"JDSBDCompletionBlockKey";

- (void)dismissAfterDelay:(NSTimeInterval)delay {
  [self dismissAfterDelay:delay completion:nil];
}

- (void)dismissAfterDelay:(NSTimeInterval)delay
             completion:(void(^ _Nullable)(void))completion {
  [_dismissTimer invalidate];

  NSDictionary *userInfo = nil;
  if (completion != nil) {
    userInfo = @{kJDStatusBarDismissCompletionBlockKey: completion};
  }

  _dismissTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:delay]
                                           interval:0 target:self selector:@selector(dismiss:)
                                           userInfo:userInfo
                                            repeats:NO];
  [[NSRunLoop currentRunLoop] addTimer:_dismissTimer forMode:NSRunLoopCommonModes];
}

- (void)dismiss:(NSTimer *)timer {
  [self dismissAnimated:YES
             completion:timer.userInfo[kJDStatusBarDismissCompletionBlockKey]];
}

- (void)dismissAnimated:(BOOL)animated {
  [self dismissAnimated:animated completion:nil];
}

- (void)dismissAnimated:(BOOL)animated
             completion:(void(^ _Nullable)(void))completion {
  [_dismissTimer invalidate];
  _dismissTimer = nil;
  
  // check animation type
  BOOL animationsEnabled = (_activeStyle.animationType != JDStatusBarAnimationTypeNone);
  animated &= animationsEnabled;
  
  dispatch_block_t animation = ^{
    if (self->_activeStyle.animationType == JDStatusBarAnimationTypeFade) {
      self->_topBar.alpha = 0.0;
    } else {
      self->_topBar.transform = CGAffineTransformMakeTranslation(0, - self->_topBar.frame.size.height);
    }
  };
  
  __weak __typeof(self) weakSelf = self;
  void(^animationCompletion)(BOOL) = ^(BOOL finished) {
    [weakSelf resetWindowAndViews];
    if (completion != nil) {
      completion();
    }
  };
  
  if (animated) {
    // animate out
    [UIView animateWithDuration:0.4 animations:animation completion:animationCompletion];
  } else {
    animation();
    animationCompletion(YES);
  }
}

- (void)resetWindowAndViews {
  [_overlayWindow removeFromSuperview];
  [_overlayWindow setHidden:YES];
  _overlayWindow.rootViewController = nil;
  _overlayWindow = nil;
  _statusBarViewController = nil;
  _progressView = nil;
  _topBar = nil;
  _activeStyle = nil;
}

#pragma mark - Bounce Animation

- (void)animateInWithBounceAnimation {
  //don't animate in, if topBar is already fully visible
  if (_topBar.frame.origin.y >= 0) {
    return;
  }
  
  // easing function (based on github.com/robb/RBBAnimation)
  CGFloat(^RBBEasingFunctionEaseOutBounce)(CGFloat) = ^CGFloat(CGFloat t) {
    if (t < 4.0 / 11.0) return pow(11.0 / 4.0, 2) * pow(t, 2);
    if (t < 8.0 / 11.0) return 3.0 / 4.0 + pow(11.0 / 4.0, 2) * pow(t - 6.0 / 11.0, 2);
    if (t < 10.0 / 11.0) return 15.0 /16.0 + pow(11.0 / 4.0, 2) * pow(t - 9.0 / 11.0, 2);
    return 63.0 / 64.0 + pow(11.0 / 4.0, 2) * pow(t - 21.0 / 22.0, 2);
  };
  
  // create values
  int fromCenterY=-20, toCenterY=0, animationSteps=100;
  NSMutableArray *values = [NSMutableArray arrayWithCapacity:animationSteps];
  for (int t = 1; t<=animationSteps; t++) {
    float easedTime = RBBEasingFunctionEaseOutBounce((t*1.0)/animationSteps);
    float easedValue = fromCenterY + easedTime * (toCenterY-fromCenterY);
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, easedValue, 0)]];
  }
  
  // build animation
  CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
  animation.duration = 0.66;
  animation.values = values;
  animation.removedOnCompletion = NO;
  animation.fillMode = kCAFillModeForwards;
  animation.delegate = self;
  [_topBar.layer setValue:@(toCenterY) forKeyPath:animation.keyPath];
  [_topBar.layer addAnimation:animation forKey:@"JDBounceAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  _topBar.transform = CGAffineTransformIdentity;
  [_topBar.layer removeAllAnimations];
}

#pragma mark - Modifications

- (void)updateStatus:(NSString *)status {
  [_topBar setStatus:status];
}

- (void)showProgressBarWithPercentage:(CGFloat)percentage {
  if (_topBar == nil) return;
  
  // trim progress
  _progress = MIN(1.0, MAX(0.0,percentage));
  
  if (_progress == 0.0) {
    _progressView.frame = CGRectZero;
    return;
  }
  
  // create view
  [self createProgressViewIfNeeded];
  
  // update superview
  if (_activeStyle.progressBarPosition == JDStatusBarProgressBarPositionBelow ||
      _activeStyle.progressBarPosition == JDStatusBarProgressBarPositionNavBar) {
    [_topBar.superview addSubview:_progressView];
  } else {
    [_topBar insertSubview:_progressView belowSubview:_topBar.textLabel];
  }
  
  // calculate progressView frame
  CGRect frame = _topBar.bounds;
  CGFloat height = MIN(frame.size.height,MAX(0.5, _activeStyle.progressBarHeight));
  if (height == 20.0 && frame.size.height > height) height = frame.size.height;
  frame.size.height = height;
  frame.size.width = round((frame.size.width - 2 * _activeStyle.progressBarHorizontalInsets) * percentage);
  frame.origin.x = _activeStyle.progressBarHorizontalInsets;
  
  // apply y-position from active style
  CGFloat barHeight = _topBar.bounds.size.height;
  if (_activeStyle.progressBarPosition == JDStatusBarProgressBarPositionBottom) {
    frame.origin.y = barHeight - height;
  } else if(_activeStyle.progressBarPosition == JDStatusBarProgressBarPositionCenter) {
    frame.origin.y = round((barHeight - height)/2.0);
  } else if(_activeStyle.progressBarPosition == JDStatusBarProgressBarPositionTop) {
    frame.origin.y = 0.0;
  } else if(_activeStyle.progressBarPosition == JDStatusBarProgressBarPositionBelow) {
    frame.origin.y = barHeight;
  } else if(_activeStyle.progressBarPosition == JDStatusBarProgressBarPositionNavBar) {
    frame.origin.y = barHeight + navBarHeight(_windowScene);
  }
  
  // apply color from active style
  _progressView.backgroundColor = _activeStyle.progressBarColor;
  
  // apply corner radius
  _progressView.layer.cornerRadius = _activeStyle.progressBarCornerRadius;
  
  // update progressView frame
  BOOL animated = !CGRectEqualToRect(_progressView.frame, CGRectZero);
  [UIView animateWithDuration:animated ? 0.05 : 0.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    self->_progressView.frame = frame;
  } completion:nil];
}

- (void)showActivityIndicator:(BOOL)show {
  if (_topBar == nil) return;
  
  if (show) {
    _topBar.activityIndicatorView.color = _activeStyle.textColor;
    [_topBar.activityIndicatorView startAnimating];
  } else {
    [_topBar.activityIndicatorView stopAnimating];
  }
}

static CGFloat navBarHeight(UIWindowScene *windowScene) {
  if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) &&
      UIInterfaceOrientationIsLandscape(JDStatusBarOrientationForWindowScene(windowScene))) {
    return 32.0;
  }
  return 44.0;
}

#pragma mark - State

- (BOOL)isVisible {
  return (_topBar != nil);
}

#pragma mark - View/Window factories

- (void)createWindowAndViewIfNeededWithStyle:(JDStatusBarStyle *)style {
  if(_overlayWindow == nil || _topBar == nil) {
    _statusBarViewController = [[JDStatusBarNotificationViewController alloc] init];
    _statusBarViewController.delegate = self;
    _statusBarViewController.statusBarSystemStyle = style.systemStatusBarStyle;

    JDStatusBarWindow *statusBarWindow;
    if (_windowScene != nil) {
      statusBarWindow = [[JDStatusBarWindow alloc] initWithWindowScene:_windowScene];
    } else {
      statusBarWindow = [[JDStatusBarWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    _overlayWindow = statusBarWindow;

    _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _overlayWindow.backgroundColor = [UIColor clearColor];
    _overlayWindow.userInteractionEnabled = YES;
    _overlayWindow.windowLevel = UIWindowLevelStatusBar;
    _overlayWindow.rootViewController = _statusBarViewController;
    _overlayWindow.rootViewController.view.backgroundColor = [UIColor clearColor];
    
    _topBar = [[JDStatusBarView alloc] initWithStyle:style];
    if (style.animationType != JDStatusBarAnimationTypeFade) {
      _topBar.transform = CGAffineTransformMakeTranslation(0, -_topBar.frame.size.height);
    } else {
      _topBar.alpha = 0.0;
    }

    statusBarWindow.topBar = _topBar;
    [_overlayWindow.rootViewController.view addSubview:_topBar];
    
    [self updateContentFrame:JDStatusBarFrameForWindowScene(_windowScene)];
  }
}

- (void)createProgressViewIfNeeded {
  if (_progressView == nil) {
    _progressView = [[UIView alloc] initWithFrame:CGRectZero];
  }
}

#pragma mark - Rotation

- (void)animationsForViewTransitionToSize:(CGSize)size {
  // update window & statusbar
  [self updateContentFrame:CGRectMake(0, 0, size.width, JDStatusBarFrameForWindowScene(_windowScene).size.height)];
  // relayout progress bar
  [self showProgressBarWithPercentage:_progress];
}

#pragma mark - Sizing

- (void)updateContentFrame:(CGRect)rect {
  // match main window transform & frame
  UIWindow *window = [[UIApplication sharedApplication] mainApplicationWindowIgnoringWindow:_overlayWindow];
  _overlayWindow.transform = window.transform;
  _overlayWindow.frame = window.frame;
  
  // default to window width
  if (CGRectIsEmpty(rect)) {
    rect = CGRectMake(0, 0, window.frame.size.width, 0.0);
  }
  
  // update top bar frame
  CGFloat heightIncludingNavBar = rect.size.height + navBarHeight(window.windowScene);
  _topBar.frame = CGRectMake(0, 0, rect.size.width, heightIncludingNavBar);
}

@end
