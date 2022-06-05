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

static const NSInteger kExpectedSubviewTag = 12321;

@implementation JDStatusBarView {
  UIActivityIndicatorView *_activityIndicatorView;
  UIView *_progressView;
  UIView *_pillBackgroundView;
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
  _textLabel.tag = kExpectedSubviewTag;
  [self addSubview:_textLabel];

  _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
  _panGestureRecognizer.enabled = YES;
  [self addGestureRecognizer:_panGestureRecognizer];
}

- (void)resetSubviewsIfNeeded {
  // remove subviews added from outside
  for (UIView *subview in self.subviews) {
    if (subview.tag != kExpectedSubviewTag) {
      [subview removeFromSuperview];
    }
  }

  // ensure expected subviews are set
  if (_textLabel.superview != self) {
    [self addSubview:_textLabel];
  }
  if (_pillBackgroundView.superview != self) {
    [self insertSubview:_pillBackgroundView belowSubview:_textLabel];
  }
  if (_progressView.superview != self) {
    [self insertSubview:_progressView belowSubview:_textLabel];
  }
  if (_activityIndicatorView.superview != self) {
    [self insertSubview:_activityIndicatorView aboveSubview:_textLabel];
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
    _activityIndicatorView.color = _style.textStyle.textColor;
    _activityIndicatorView.tag = kExpectedSubviewTag;
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

#pragma mark - pill background

- (void)createPillBackgroundViewIfNeeded {
  if (_pillBackgroundView == nil) {
    _pillBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _pillBackgroundView.backgroundColor = _style.backgroundStyle.backgroundColor;
    _pillBackgroundView.tag = kExpectedSubviewTag;
    [self addSubview:_pillBackgroundView];
    [self sendSubviewToBack:_pillBackgroundView];
  }
}

- (CGRect)outerRectForBackgroundStyle {
  switch (_style.backgroundStyle.backgroundType) {
    case JDStatusBarBackgroundTypeClassic:
      return self.bounds;
    case JDStatusBarBackgroundTypePill:
      return _pillBackgroundView.frame;
  }
}

#pragma mark - progress bar

- (void)createProgressViewIfNeeded {
  if (_progressView == nil) {
    _progressView = [[UIView alloc] initWithFrame:CGRectZero];
    _progressView.backgroundColor = _style.progressBarStyle.barColor;
    _progressView.layer.cornerRadius = _style.progressBarStyle.cornerRadius;
    _progressView.frame = [self progressViewRectForPercentage:0.0];
    _progressView.tag = kExpectedSubviewTag;
    [self insertSubview:_progressView belowSubview:_textLabel];
    [self sendSubviewToBack:_pillBackgroundView];
  }
}

- (CGRect)progressViewRectForPercentage:(CGFloat)percentage {
  JDStatusBarProgressBarStyle *progressBarStyle = _style.progressBarStyle;

  // calculate progressView frame
  CGRect outerRect = [self outerRectForBackgroundStyle];
  CGSize bounds = outerRect.size;
  CGFloat barHeight = MIN(bounds.height, MAX(0.5, progressBarStyle.barHeight));
  CGFloat width = round((bounds.width - 2 * progressBarStyle.horizontalInsets) * percentage);
  CGRect barFrame = CGRectMake(outerRect.origin.x + progressBarStyle.horizontalInsets, outerRect.origin.y, width, barHeight);

  // calculate y-position
  switch (_style.progressBarStyle.position) {
    case JDStatusBarProgressBarPositionBottom:
      barFrame.origin.y += bounds.height - barHeight + progressBarStyle.offsetY;
      break;
    case JDStatusBarProgressBarPositionCenter:
      barFrame.origin.y = round(_textLabel.center.y - (barHeight / 2.0)) + progressBarStyle.offsetY;
      break;
    case JDStatusBarProgressBarPositionTop:
      barFrame.origin.y += CGRectGetMinY(_textLabel.frame) + progressBarStyle.offsetY;
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
    _progressView.frame = [self progressViewRectForPercentage:0.0];
    return;
  }

  // create view & reset state
  [self createProgressViewIfNeeded];
  _progressView.hidden = NO;

  // update progressView frame
  CGRect frame = [self progressViewRectForPercentage:_progressBarPercentage];

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

  [self applyStyleForBackgroundType];

  // style label
  JDStatusBarTextStyle *textSyle = style.textStyle;
  _textLabel.textColor = textSyle.textColor;
  _textLabel.font = textSyle.font;
  if (textSyle.textShadowColor != nil) {
    _textLabel.shadowColor = textSyle.textShadowColor;
    _textLabel.shadowOffset = textSyle.textShadowOffset;
  } else {
    _textLabel.shadowColor = nil;
    _textLabel.shadowOffset = CGSizeZero;
  }

  // style other views
  _activityIndicatorView.color = textSyle.textColor;
  _progressView.backgroundColor = style.progressBarStyle.barColor;
  _progressView.layer.cornerRadius = style.progressBarStyle.cornerRadius;

  // update gesture recognizer
  _panGestureRecognizer.enabled = style.canSwipeToDismiss;
  
  [self setNeedsLayout];
}

- (void)applyStyleForBackgroundType {
  JDStatusBarBackgroundStyle *backgroundStyle = _style.backgroundStyle;
  switch (backgroundStyle.backgroundType) {
    case JDStatusBarBackgroundTypeClassic:
      self.backgroundColor = backgroundStyle.backgroundColor;
      break;
    case JDStatusBarBackgroundTypePill: {
      self.backgroundColor = [UIColor clearColor];
      [self createPillBackgroundViewIfNeeded];
      _pillBackgroundView.backgroundColor = backgroundStyle.backgroundColor;
      break;
    }
  }
}

#pragma mark - layout

- (void)layoutSubviews {
  [super layoutSubviews];
  
  // layout margins
  CGFloat topLayoutMargin = JDStatusBarRootVCLayoutMarginForWindow(self.window).top;
  CGFloat labelAdjustment = topLayoutMargin;
  if (topLayoutMargin == 0) {
    labelAdjustment = JDStatusBarFrameForWindowScene(self.window.windowScene).size.height;
  }

  CGFloat pillInset = 20.0;
  CGFloat labelInset = 30.0;
  switch (_style.backgroundStyle.backgroundType) {
    case JDStatusBarBackgroundTypeClassic:
      break;
    case JDStatusBarBackgroundTypePill:
      labelInset += pillInset;
      break;
  }

  // text label
  CGFloat labelY = _style.textStyle.textOffsetY + labelAdjustment;
  CGFloat height = self.bounds.size.height - labelAdjustment;
  CGFloat activitySpacing = 16.0;
  CGFloat activityWidth = CGRectGetWidth(_activityIndicatorView.frame);
  if (_displaysActivityIndicator) {
    labelInset += activityWidth + activitySpacing;
  }
  _textLabel.frame = CGRectMake(labelInset, labelY, self.bounds.size.width - labelInset * 2, height);

  // pill background
  if (_pillBackgroundView) {
    _pillBackgroundView.frame = CGRectInset(CGRectMake(pillInset, labelY, self.bounds.size.width - pillInset * 2, height), 0.0, 6.0);
    _pillBackgroundView.layer.cornerRadius = CGRectGetHeight(_pillBackgroundView.frame) / 2.0;
  }

  // progress view
  if (_progressView && _progressView.layer.animationKeys.count == 0) {
    _progressView.frame = [self progressViewRectForPercentage:_progressBarPercentage];
  }
  
  // activity indicator
  if (_activityIndicatorView) {
    NSDictionary *attributes = @{NSFontAttributeName:_textLabel.font};
    CGFloat textWidth = MIN([_textLabel.text sizeWithAttributes:attributes].width, CGRectGetWidth(_textLabel.frame));
    CGRect indicatorFrame = _activityIndicatorView.frame;
    indicatorFrame.origin.x = round((self.bounds.size.width - textWidth)/2.0) - indicatorFrame.size.width - activitySpacing;
    indicatorFrame.origin.y = labelY + 1 + floor((CGRectGetHeight(_textLabel.bounds) - CGRectGetHeight(indicatorFrame))/2.0);
    _activityIndicatorView.frame = indicatorFrame;
  }

  // layer masking
  switch (_style.backgroundStyle.backgroundType) {
    case JDStatusBarBackgroundTypeClassic: {
      self.layer.mask = nil;
      break;
    }
    case JDStatusBarBackgroundTypePill: {
      CGRect frame = CGRectInset(CGRectMake(pillInset, labelY, self.bounds.size.width - pillInset * 2, height), 0.0, 6.0);
      UIBezierPath *roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:frame
                                                                 cornerRadius:height / 2.0];
      CAShapeLayer *maskLayer = [CAShapeLayer layer];
      maskLayer.path = roundedRectPath.CGPath;
      self.layer.mask = maskLayer;
      break;
    }
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
