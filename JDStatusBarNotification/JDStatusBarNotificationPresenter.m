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
#import "JDStatusBarLayoutMarginHelper.h"
#import "UIApplication+MainWindow.h"
#import "JDStatusBarNotificationViewController.h"

@interface JDStatusBarStyle (Hidden)
+ (NSArray *)allDefaultStyleIdentifier;
+ (JDStatusBarStyle *)defaultStyleWithName:(NSString *)styleName;
@end

@interface JDStatusBarNotificationPresenter () <CAAnimationDelegate>

@property (nonatomic, strong, readonly) UIWindowScene *windowScene;
@property (nonatomic, strong, readonly) UIWindow *overlayWindow;
@property (nonatomic, strong, readonly) UIView *progressView;
@property (nonatomic, strong, readonly) JDStatusBarView *topBar;

@property (nonatomic, strong) NSTimer *dismissTimer;
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) JDStatusBarStyle *activeStyle;
@property (nonatomic, strong) JDStatusBarStyle *defaultStyle;
@property (nonatomic, strong) NSMutableDictionary *userStyles;

@end

@implementation JDStatusBarNotificationPresenter

@synthesize windowScene = _windowScene;
@synthesize overlayWindow = _overlayWindow;
@synthesize progressView = _progressView;
@synthesize topBar = _topBar;

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

- (instancetype)init
{
  if ((self = [super init]))
  {
    // set defaults
    [self setupDefaultStyles];

    // register for orientation changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrame:)
                                                 name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Window Scene

- (void)setWindowScene:(UIWindowScene *)windowScene {
  _windowScene = windowScene;
}

#pragma mark - Custom styles

- (void)setupDefaultStyles {
  self.defaultStyle = [JDStatusBarStyle defaultStyleWithName:JDStatusBarStyleDefault];

  self.userStyles = [NSMutableDictionary dictionary];
  for (NSString *styleName in [JDStatusBarStyle allDefaultStyleIdentifier]) {
    [self.userStyles setObject:[JDStatusBarStyle defaultStyleWithName:styleName] forKey:styleName];
  }
}

- (void)updateDefaultStyle:(JDStatusBarPrepareStyleBlock)prepareBlock {
  NSAssert(prepareBlock != nil, @"No prepareBlock provided");
  self.defaultStyle = prepareBlock([self.defaultStyle copy]);
}

- (NSString*)addStyleNamed:(NSString*)identifier
                   prepare:(JDStatusBarPrepareStyleBlock)prepareBlock {
  NSAssert(identifier != nil, @"No identifier provided");
  NSAssert(prepareBlock != nil, @"No prepareBlock provided");

  JDStatusBarStyle *style = [self.defaultStyle copy];
  [self.userStyles setObject:prepareBlock(style) forKey:identifier];
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
    style = self.userStyles[styleName];
  }

  if (style == nil) style = self.defaultStyle;
  JDStatusBarView *view = [self showWithStatus:status style:style];
  if (timeInterval > 0.0) {
    [self dismissAfterDelay:timeInterval];
  }
  return view;
}

- (JDStatusBarView *)showWithStatus:(NSString *)status
                              style:(JDStatusBarStyle *)style {
  // prepare for new style
  if (style != self.activeStyle) {
    self.activeStyle = style;
    if (self.activeStyle.animationType == JDStatusBarAnimationTypeFade) {
      self.topBar.alpha = 0.0;
      self.topBar.transform = CGAffineTransformIdentity;
    } else {
      self.topBar.alpha = 1.0;
      self.topBar.transform = CGAffineTransformMakeTranslation(0, -self.topBar.frame.size.height);
    }
  }

  // Force update the TopBar frame if the height is 0
  if (self.topBar.frame.size.height == 0) {
    [self updateContentFrame:[[UIApplication sharedApplication] statusBarFrame]];
  }

  // cancel previous dismissing & remove animations
  [[NSRunLoop currentRunLoop] cancelPerformSelector:@selector(dismiss) target:self argument:nil];
  [self.topBar.layer removeAllAnimations];

  // create & show window
  [self.overlayWindow setHidden:NO];

  // update style
  self.topBar.backgroundColor = style.barColor;
  self.topBar.textVerticalPositionAdjustment = style.textVerticalPositionAdjustment;
  UILabel *textLabel = self.topBar.textLabel;
  textLabel.textColor = style.textColor;
  textLabel.font = style.font;
  textLabel.accessibilityLabel = status;
  textLabel.text = status;

  if (style.textShadow) {
    textLabel.shadowColor = style.textShadow.shadowColor;
    textLabel.shadowOffset = style.textShadow.shadowOffset;
  } else {
    textLabel.shadowColor = nil;
    textLabel.shadowOffset = CGSizeZero;
  }

  // reset progress & activity
  [self showProgressBarWithPercentage:0.0];
  [self showActivityIndicator:NO];

  // animate in
  BOOL animationsEnabled = (style.animationType != JDStatusBarAnimationTypeNone);
  if (animationsEnabled && style.animationType == JDStatusBarAnimationTypeBounce) {
    [self animateInWithBounceAnimation];
  } else {
    [UIView animateWithDuration:(animationsEnabled ? 0.4 : 0.0) animations:^{
      self.topBar.alpha = 1.0;
      self.topBar.transform = CGAffineTransformIdentity;
    }];
  }

  return self.topBar;
}

#pragma mark - Dismissal

- (void)dismissAfterDelay:(NSTimeInterval)interval {
  [self.dismissTimer invalidate];
  self.dismissTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]
                                               interval:0 target:self selector:@selector(dismiss:) userInfo:nil repeats:NO];
  [[NSRunLoop currentRunLoop] addTimer:self.dismissTimer forMode:NSRunLoopCommonModes];
}

- (void)dismiss:(NSTimer *)timer {
  [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated {
  [self.dismissTimer invalidate];
  self.dismissTimer = nil;

  // check animation type
  BOOL animationsEnabled = (self.activeStyle.animationType != JDStatusBarAnimationTypeNone);
  animated &= animationsEnabled;

  dispatch_block_t animation = ^{
    if (self.activeStyle.animationType == JDStatusBarAnimationTypeFade) {
      self.topBar.alpha = 0.0;
    } else {
      self.topBar.transform = CGAffineTransformMakeTranslation(0, -self.topBar.frame.size.height);
    }
  };

  void(^complete)(BOOL) = ^(BOOL finished) {
    [self.overlayWindow removeFromSuperview];
    [self.overlayWindow setHidden:YES];
    self.overlayWindow.rootViewController = nil;
    self->_overlayWindow = nil;
    self->_progressView = nil;
    self->_topBar = nil;
  };

  if (animated) {
    // animate out
    [UIView animateWithDuration:0.4 animations:animation completion:complete];
  } else {
    animation();
    complete(YES);
  }
}

#pragma mark - Bounce Animation

- (void)animateInWithBounceAnimation {
  //don't animate in, if topBar is already fully visible
  if (self.topBar.frame.origin.y >= 0) {
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
  [self.topBar.layer setValue:@(toCenterY) forKeyPath:animation.keyPath];
  [self.topBar.layer addAnimation:animation forKey:@"JDBounceAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  self.topBar.transform = CGAffineTransformIdentity;
  [self.topBar.layer removeAllAnimations];
}

#pragma mark - Modifications

- (void)updateStatus:(NSString *)status {
  if (_topBar == nil) return;

  UILabel *textLabel = self.topBar.textLabel;
  textLabel.accessibilityLabel = status;
  textLabel.text = status;

  [self.topBar setNeedsLayout];
}

- (void)showProgressBarWithPercentage:(CGFloat)percentage {
  if (_topBar == nil) return;

  // trim progress
  _progress = MIN(1.0, MAX(0.0,percentage));

  if (_progress == 0.0) {
    _progressView.frame = CGRectZero;
    return;
  }

  // update superview
  if (self.activeStyle.progressBarPosition == JDStatusBarProgressBarPositionBelow ||
      self.activeStyle.progressBarPosition == JDStatusBarProgressBarPositionNavBar) {
    [self.topBar.superview addSubview:self.progressView];
  } else {
    [self.topBar insertSubview:self.progressView belowSubview:self.topBar.textLabel];
  }

  // calculate progressView frame
  CGRect frame = self.topBar.bounds;
  CGFloat height = MIN(frame.size.height,MAX(0.5, self.activeStyle.progressBarHeight));
  if (height == 20.0 && frame.size.height > height) height = frame.size.height;
  frame.size.height = height;
  frame.size.width = round((frame.size.width - 2 * self.activeStyle.progressBarHorizontalInsets) * percentage);
  frame.origin.x = self.activeStyle.progressBarHorizontalInsets;

  // apply y-position from active style
  CGFloat barHeight = self.topBar.bounds.size.height;
  if (self.activeStyle.progressBarPosition == JDStatusBarProgressBarPositionBottom) {
    frame.origin.y = barHeight - height;
  } else if(self.activeStyle.progressBarPosition == JDStatusBarProgressBarPositionCenter) {
    frame.origin.y = round((barHeight - height)/2.0);
  } else if(self.activeStyle.progressBarPosition == JDStatusBarProgressBarPositionTop) {
    frame.origin.y = 0.0;
  } else if(self.activeStyle.progressBarPosition == JDStatusBarProgressBarPositionBelow) {
    frame.origin.y = barHeight;
  } else if(self.activeStyle.progressBarPosition == JDStatusBarProgressBarPositionNavBar) {
    frame.origin.y = barHeight + navBarHeight(_windowScene);
  }

  // apply color from active style
  self.progressView.backgroundColor = self.activeStyle.progressBarColor;

  // apply corner radius
  self.progressView.layer.cornerRadius = self.activeStyle.progressBarCornerRadius;

  // update progressView frame
  BOOL animated = !CGRectEqualToRect(self.progressView.frame, CGRectZero);
  [UIView animateWithDuration:animated ? 0.05 : 0.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    self.progressView.frame = frame;
  } completion:nil];
}

- (void)showActivityIndicator:(BOOL)show {
    if (_topBar == nil) return;

    if (show) {
        self.topBar.activityIndicatorView.color = self.activeStyle.textColor;
        [self.topBar.activityIndicatorView startAnimating];
    } else {
        [self.topBar.activityIndicatorView stopAnimating];
    }
}

static CGFloat navBarHeight(UIWindowScene *windowScene) {
    if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) &&
        UIInterfaceOrientationIsLandscape(windowScene != nil
                                          ? windowScene.interfaceOrientation
                                          : [[UIApplication sharedApplication] statusBarOrientation])) {
      return 32.0;
    }
    return 44.0;
}

#pragma mark - State

- (BOOL)isVisible {
  return (_topBar != nil);
}

#pragma mark - Lazy views

- (UIWindow *)overlayWindow {
  if(_overlayWindow == nil) {
      if (_windowScene != nil) {
        _overlayWindow = [[UIWindow alloc] initWithWindowScene:_windowScene];
      } else {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
      }
    _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _overlayWindow.backgroundColor = [UIColor clearColor];
    _overlayWindow.userInteractionEnabled = NO;
    _overlayWindow.windowLevel = UIWindowLevelStatusBar;
    _overlayWindow.rootViewController = [[JDStatusBarNotificationViewController alloc] init];
    _overlayWindow.rootViewController.view.backgroundColor = [UIColor clearColor];
    [self updateContentFrame:[[UIApplication sharedApplication] statusBarFrame]];
  }
  return _overlayWindow;
}

- (JDStatusBarView *)topBar {
  if(_topBar == nil) {
    _topBar = [[JDStatusBarView alloc] init];
    [self.overlayWindow.rootViewController.view addSubview:_topBar];

    JDStatusBarStyle *style = self.activeStyle ?: self.defaultStyle;
    _topBar.heightForIPhoneX = style.heightForIPhoneX;
    if (style.animationType != JDStatusBarAnimationTypeFade) {
      _topBar.transform = CGAffineTransformMakeTranslation(0, -_topBar.frame.size.height);
    } else {
      _topBar.alpha = 0.0;
    }
  }
  return _topBar;
}

- (UIView *)progressView {
  if (_progressView == nil) {
    _progressView = [[UIView alloc] initWithFrame:CGRectZero];
  }
  return _progressView;
}

#pragma mark - Rotation

- (void)updateContentFrame:(CGRect)rect {
    // match main window transform & frame
    UIWindow *window = [[UIApplication sharedApplication] mainApplicationWindowIgnoringWindow:self.overlayWindow];
    _overlayWindow.transform = window.transform;
    _overlayWindow.frame = window.frame;

    // default to window width
    if (CGRectIsEmpty(rect)) {
        rect = CGRectMake(0, 0, window.frame.size.width, 0.0);
    }

    // update top bar frame
    CGFloat width = MAX(rect.size.width, rect.size.height);
    CGFloat height = MIN(rect.size.width, rect.size.height);
    height = topBarHeightAdjustedForIphoneX(self.activeStyle ?: self.defaultStyle, height, window);
    _topBar.frame = CGRectMake(0, 0, width, height);

}

static CGFloat topBarHeightAdjustedForIphoneX(JDStatusBarStyle *style, CGFloat height, UIWindow *mainWindow) {
  if (JDStatusBarRootVCLayoutMarginForWindow(mainWindow).top > 0) {
    switch (style.heightForIPhoneX) {
      case JDStatusBarHeightForIPhoneXFullNavBar:
        return height + navBarHeight(mainWindow.windowScene);
      case JDStatusBarHeightForIPhoneXHalf:
        return height + 8.0;
    }
  } else {
      // Starting with iOS 13 we can't be on top of the status bar anymore.
      // Thus start presenting a larger status bar notification similar to the
      // iPhone-X style also on no-notch devices (e.g. SE).
      if (@available(iOS 13, *)) {
          return height + navBarHeight(mainWindow.windowScene);
      }
      return height;
  }
}

- (void)willChangeStatusBarFrame:(NSNotification *)notification {
  CGRect newBarFrame = [notification.userInfo[UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
  NSTimeInterval duration = [[UIApplication sharedApplication] statusBarOrientationAnimationDuration];

  [UIView animateWithDuration:duration animations:^{
      // update window & statusbar
      [self updateContentFrame:newBarFrame];
      // relayout progress bar
      [self showProgressBarWithPercentage:_progress];
  }];
}

@end
