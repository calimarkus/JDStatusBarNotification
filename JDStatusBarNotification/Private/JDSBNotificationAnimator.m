//
//

#import "JDSBNotificationAnimator.h"

#import "JDStatusBarNotificationStyle.h"
#import "JDSBNotificationView.h"

@interface JDSBNotificationAnimator () <CAAnimationDelegate>
@end

@implementation JDSBNotificationAnimator {
  JDSBNotificationView *_statusBarView;
  JDSBNotificationAnimatorCompletion _animateInCompletionBlock;
}

- (instancetype)initWithStatusBarView:(JDSBNotificationView *)statusBarView {
  self = [super init];
  if (self) {
    _statusBarView = statusBarView;
  }
  return self;
}

- (void)animateInWithDuration:(CGFloat)duration
                   completion:(JDSBNotificationAnimatorCompletion)completion {
  JDStatusBarNotificationStyle *style = _statusBarView.style;
  JDSBNotificationView *view = _statusBarView;

  // reset animation state
  _animateInCompletionBlock = nil;
  [view.layer removeAllAnimations];

  // set initial view state
  if (style.animationType == JDStatusBarNotificationAnimationTypeFade) {
    view.alpha = 0.0;
    view.transform = CGAffineTransformIdentity;
  } else {
    view.alpha = 1.0;
    view.transform = CGAffineTransformMakeTranslation(0, - CGRectGetHeight(view.bounds));
  }

  // animate in
  if (style.animationType == JDStatusBarNotificationAnimationTypeBounce) {
    _animateInCompletionBlock = completion;
    [self animateInWithBounceAnimation];
  } else {
    [UIView animateWithDuration:duration animations:^{
      view.alpha = 1.0;
      view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
      if (finished && completion != nil) {
        completion();
      }
    }];
  }
}

- (void)animateInWithBounceAnimation {
  JDSBNotificationView *topBar = _statusBarView;

  // easing function (based on github.com/robb/RBBAnimation)
  CGFloat(^RBBEasingFunctionEaseOutBounce)(CGFloat) = ^CGFloat(CGFloat t) {
    if (t < 4.0 / 11.0) return pow(11.0 / 4.0, 2) * pow(t, 2);
    if (t < 8.0 / 11.0) return 3.0 / 4.0 + pow(11.0 / 4.0, 2) * pow(t - 6.0 / 11.0, 2);
    if (t < 10.0 / 11.0) return 15.0 /16.0 + pow(11.0 / 4.0, 2) * pow(t - 9.0 / 11.0, 2);
    return 63.0 / 64.0 + pow(11.0 / 4.0, 2) * pow(t - 21.0 / 22.0, 2);
  };

  // create values
  int fromCenterY = -topBar.bounds.size.height, toCenterY=0, animationSteps=200;
  NSMutableArray *values = [NSMutableArray arrayWithCapacity:animationSteps];
  for (int t = 1; t<=animationSteps; t++) {
    float easedTime = RBBEasingFunctionEaseOutBounce((t*1.0)/animationSteps);
    float easedValue = fromCenterY + easedTime * (toCenterY-fromCenterY);
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, easedValue, 0)]];
  }

  // build animation
  CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
  animation.duration = 0.75;
  animation.values = values;
  animation.removedOnCompletion = NO;
  animation.fillMode = kCAFillModeForwards;
  animation.delegate = self;
  [topBar.layer setValue:@(toCenterY) forKeyPath:animation.keyPath];
  [topBar.layer addAnimation:animation forKey:@"JDBounceAnimation"];
}

- (void)animateOutWithDuration:(CGFloat)duration
                    completion:(JDSBNotificationAnimatorCompletion)completion {
  JDStatusBarNotificationStyle *style = _statusBarView.style;
  JDSBNotificationView *view = _statusBarView;

  // animate out
  [UIView animateWithDuration:duration animations:^{
    if (style.animationType == JDStatusBarNotificationAnimationTypeFade) {
      view.alpha = 0.0;
    } else {
      view.transform = CGAffineTransformMakeTranslation(0, - CGRectGetHeight(view.bounds));
    }
  } completion:^(BOOL finished) {
    if (finished && completion != nil) {
      completion();
    }
  }];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished {
  if (finished) {
    JDSBNotificationView *topBar = _statusBarView;
    topBar.transform = CGAffineTransformIdentity;
    [topBar.layer removeAllAnimations];

    if (_animateInCompletionBlock) {
      JDSBNotificationAnimatorCompletion completion = _animateInCompletionBlock;
      _animateInCompletionBlock = nil;
      if (completion) {
        completion();
      }
    }
  }
}

@end
