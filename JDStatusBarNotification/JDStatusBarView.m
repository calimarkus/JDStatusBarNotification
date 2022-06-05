//
//  JDStatusBarView.m
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "JDStatusBarView.h"
#import "JDStatusBarView_Private.h"

#import "JDStatusBarStyle.h"
#import "JDStatusBarLayoutMarginHelper.h"
#import "JDStatusBarManagerHelper.h"

@implementation JDStatusBarView {
  UIActivityIndicatorView *_activityIndicatorView;
  UIView *_progressView;
  JDStatusBarStyle *_style;
}

@synthesize textLabel = _textLabel;
@synthesize panGestureRecognizer = _panGestureRecognizer;

- (instancetype)initWithStyle:(JDStatusBarStyle *)style {
  self = [super init];
  if (self) {
    [self setupView];
    [self setStyle:style];
  }
  return self;
}

#pragma mark - view setup

- (void)setupView {
  self.clipsToBounds = YES;

  _textLabel = [[UILabel alloc] init];
  _textLabel.backgroundColor = [UIColor clearColor];
  _textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
  _textLabel.textAlignment = NSTextAlignmentCenter;
  _textLabel.adjustsFontSizeToFitWidth = YES;
  _textLabel.clipsToBounds = YES;
  [self addSubview:_textLabel];

  _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
  _panGestureRecognizer.enabled = YES;
  [self addGestureRecognizer:_panGestureRecognizer];
}

- (void)resetSubviewsIfNeeded {
  // remove subviews added from outside
  for (UIView *subview in self.subviews) {
    if (subview != _textLabel && subview != _activityIndicatorView && subview != _progressView) {
      [subview removeFromSuperview];
    }
  }

  // ensure expected subviews are set
  if (_textLabel.superview != self) {
    [self addSubview:_textLabel];
  }
  if (_activityIndicatorView != nil && _activityIndicatorView.superview != self) {
    [self addSubview:_activityIndicatorView];
  }
  if (_progressView != nil && _progressView.superview != self) {
    [self insertSubview:_progressView belowSubview:_textLabel];
  }

  // ensure pan recognizer is setup
  _panGestureRecognizer.enabled = YES;
  [self addGestureRecognizer:_panGestureRecognizer];
}

#pragma mark - acitivity indicator

- (void)createActivityIndicatorViewIfNeeded {
  if (_activityIndicatorView == nil) {
    _activityIndicatorView = [UIActivityIndicatorView new];
    _activityIndicatorView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    _activityIndicatorView.color = _style.textColor;
    [self addSubview:_activityIndicatorView];
  }
}

- (void)setDisplaysActivityIndicator:(BOOL)displaysActivityIndicator {
  _displaysActivityIndicator = displaysActivityIndicator;

  if (displaysActivityIndicator) {
    [self createActivityIndicatorViewIfNeeded];
    [_activityIndicatorView startAnimating];
  } else {
    [_activityIndicatorView stopAnimating];
  }
}

#pragma mark - progress bar

- (void)createProgressViewIfNeeded {
  if (_progressView == nil) {
    _progressView = [[UIView alloc] initWithFrame:CGRectZero];
    _progressView.backgroundColor = _style.progressBarStyle.barColor;
    _progressView.layer.cornerRadius = _style.progressBarStyle.cornerRadius;
    _progressView.frame = [self prograssViewRectForPercentage:0.0];
    [self insertSubview:_progressView belowSubview:_textLabel];
  }
}

- (CGRect)prograssViewRectForPercentage:(CGFloat)percentage {
  JDStatusBarProgressBarStyle *progressBarStyle = _style.progressBarStyle;

  // calculate progressView frame
  CGSize bounds = self.bounds.size;
  CGFloat barHeight = MIN(bounds.height, MAX(0.5, progressBarStyle.barHeight));
  CGFloat width = round((bounds.width - 2 * progressBarStyle.horizontalInsets) * percentage);
  CGRect barFrame = CGRectMake(progressBarStyle.horizontalInsets, 0, width, barHeight);

  // calculate y-position
  switch (_style.progressBarStyle.position) {
    case JDStatusBarProgressBarPositionBottom:
      barFrame.origin.y = bounds.height - barHeight;
      break;
    case JDStatusBarProgressBarPositionCenter:
      barFrame.origin.y = round(_textLabel.center.y - (barHeight / 2.0));
      break;
    case JDStatusBarProgressBarPositionTop:
      barFrame.origin.y = 0.0;
      break;
  }

  return barFrame;
}

- (void)setProgressBarPercentage:(CGFloat)percentage {
  [self setProgressBarPercentage:percentage animationDuration:0.0 completion:nil];
}

- (void)setProgressBarPercentage:(CGFloat)percentage
               animationDuration:(CGFloat)animationDuration
                      completion:(void(^ _Nullable)(void))completion {
  // clamp progress
  _progressBarPercentage = MIN(1.0, MAX(0.0, percentage));

  // reset animations
  [_progressView.layer removeAllAnimations];

  // reset view
  if (_progressBarPercentage == 0.0) {
    _progressView.hidden = YES;
    _progressView.frame = [self prograssViewRectForPercentage:0.0];
    return;
  }

  // create view & reset state
  [self createProgressViewIfNeeded];
  _progressView.hidden = NO;

  // update progressView frame
  CGRect frame = [self prograssViewRectForPercentage:_progressBarPercentage];

  if (animationDuration == 0.0) {
    _progressView.frame = frame;
    if (completion != nil) {
      completion();
    }
  } else {
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
      self->_progressView.frame = frame;
    } completion:^(BOOL finished) {
      if (finished && completion) {
        completion();
      }
    }];
  }
}

#pragma mark - properties

- (NSString *)text {
  return _textLabel.text ?: @"";
}

- (void)setText:(NSString *)text {
  _textLabel.accessibilityLabel = text;
  _textLabel.text = text;
  
  [self setNeedsLayout];
}

- (void)setStyle:(JDStatusBarStyle *)style {
  _style = style;
  
  self.backgroundColor = style.barColor;

  // style label
  _textLabel.textColor = style.textColor;
  _textLabel.font = style.font;
  if (style.textShadowColor != nil) {
    _textLabel.shadowColor = style.textShadowColor;
    _textLabel.shadowOffset = style.textShadowOffset;
  } else {
    _textLabel.shadowColor = nil;
    _textLabel.shadowOffset = CGSizeZero;
  }

  // style other views
  _activityIndicatorView.color = style.textColor;
  _progressView.backgroundColor = style.progressBarStyle.barColor;
  _progressView.layer.cornerRadius = style.progressBarStyle.cornerRadius;

  // update gesture recognizer
  _panGestureRecognizer.enabled = style.canSwipeToDismiss;
  
  [self setNeedsLayout];
}

#pragma mark - layout

- (void)layoutSubviews {
  [super layoutSubviews];
  
  // label
  CGFloat topLayoutMargin = JDStatusBarRootVCLayoutMarginForWindow(self.window).top;
  CGFloat labelAdjustment = topLayoutMargin;
  if (topLayoutMargin == 0) {
    labelAdjustment = JDStatusBarFrameForWindowScene(self.window.windowScene).size.height;
  }
  
  CGFloat labelY = _style.textVerticalPositionAdjustment + labelAdjustment + 1;
  CGFloat height = self.bounds.size.height - labelAdjustment - 1;

  CGFloat inset = 30.0;
  CGFloat activitySpacing = 16.0;
  CGFloat activityWidth = CGRectGetWidth(_activityIndicatorView.frame);
  if (_activityIndicatorView) {
    inset += activityWidth + activitySpacing;
  }
  self.textLabel.frame = CGRectMake(inset, labelY, self.bounds.size.width - inset * 2, height);

  if (_progressView && _progressView.layer.animationKeys.count == 0) {
    _progressView.frame = [self prograssViewRectForPercentage:_progressBarPercentage];
  }
  
  // activity indicator
  if (_activityIndicatorView) {
    NSDictionary *attributes = @{NSFontAttributeName:self.textLabel.font};
    CGFloat textWidth = MIN([self.textLabel.text sizeWithAttributes:attributes].width, CGRectGetWidth(_textLabel.frame));
    CGRect indicatorFrame = _activityIndicatorView.frame;
    indicatorFrame.origin.x = round((self.bounds.size.width - textWidth)/2.0) - indicatorFrame.size.width - activitySpacing;
    indicatorFrame.origin.y = labelY + 1 + floor((CGRectGetHeight(self.textLabel.bounds) - CGRectGetHeight(indicatorFrame))/2.0);
    _activityIndicatorView.frame = indicatorFrame;
  }
}

#pragma mark - Pan gesture

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer {
  if (recognizer.isEnabled) {
    CGPoint translation = [recognizer translationInView:self];
    switch (recognizer.state) {
      case UIGestureRecognizerStateBegan:
        [recognizer setTranslation:CGPointZero inView:self];
        break;
      case UIGestureRecognizerStateChanged: {
        self.transform = CGAffineTransformMakeTranslation(0, MIN(translation.y, 0.0));
        break;
      }
      case UIGestureRecognizerStateEnded:
      case UIGestureRecognizerStateCancelled:
      case UIGestureRecognizerStateFailed:
        if (translation.y > -(self.bounds.size.height * 0.20)) {
          [UIView animateWithDuration:0.22 animations:^{
            self.transform = CGAffineTransformIdentity;
          }];
        } else {
          [self.delegate statusBarViewDidPanToDismiss];
        }
      default:
        break;
    }
  }
}

@end
