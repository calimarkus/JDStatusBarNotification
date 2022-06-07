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
  _textLabel = [[UILabel alloc] init];
  _textLabel.backgroundColor = [UIColor clearColor];
  _textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
  _textLabel.textAlignment = NSTextAlignmentCenter;
  _textLabel.adjustsFontSizeToFitWidth = YES;
  _textLabel.clipsToBounds = YES;
  _textLabel.tag = kExpectedSubviewTag;

#if JDSB_LAYOUT_DEBUGGING
  _textLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
  _textLabel.layer.borderWidth = 1.0;
#endif

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
    [_activityIndicatorView sizeToFit];
    _activityIndicatorView.color = _style.textStyle.textColor;
    _activityIndicatorView.tag = kExpectedSubviewTag;

#if JDSB_LAYOUT_DEBUGGING
    _activityIndicatorView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _activityIndicatorView.layer.borderWidth = 1.0;
#endif

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

  [self setNeedsLayout];
}

#pragma mark - pill background

- (void)createPillBackgroundViewIfNeeded {
  if (_pillBackgroundView == nil) {
    _pillBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _pillBackgroundView.tag = kExpectedSubviewTag;
    [self addSubview:_pillBackgroundView];
    [self sendSubviewToBack:_pillBackgroundView];
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

- (CGRect)progressViewContentRectForBackgroundStyle {
  switch (_style.backgroundStyle.backgroundType) {
    case JDStatusBarBackgroundTypeClassic:
      return contentRectForWindow(self);
    case JDStatusBarBackgroundTypePill:
      return _pillBackgroundView.frame;
  }
}

- (CGRect)progressViewRectForPercentage:(CGFloat)percentage {
  JDStatusBarProgressBarStyle *progressBarStyle = _style.progressBarStyle;

  // calculate progressView frame
  CGRect contentRect = [self progressViewContentRectForBackgroundStyle];
  CGFloat barHeight = MIN(contentRect.size.height, MAX(0.5, progressBarStyle.barHeight));
  CGFloat width = round((contentRect.size.width - 2 * progressBarStyle.horizontalInsets) * percentage);
  CGRect barFrame = CGRectMake(contentRect.origin.x + progressBarStyle.horizontalInsets, progressBarStyle.offsetY, width, barHeight);

  // calculate y-position
  switch (_style.progressBarStyle.position) {
    case JDStatusBarProgressBarPositionTop:
      barFrame.origin.y += contentRect.origin.y;
      break;
    case JDStatusBarProgressBarPositionCenter:
      barFrame.origin.y += _style.textStyle.textOffsetY + contentRect.origin.y + round((contentRect.size.height - barHeight) / 2.0) + 1;
      break;
    case JDStatusBarProgressBarPositionBottom:
      barFrame.origin.y += contentRect.origin.y + contentRect.size.height - barHeight;
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

  [_delegate didUpdateStyle];
}

- (void)applyStyleForBackgroundType {
  JDStatusBarBackgroundStyle *backgroundStyle = _style.backgroundStyle;
  switch (backgroundStyle.backgroundType) {
    case JDStatusBarBackgroundTypeClassic:
      self.backgroundColor = backgroundStyle.backgroundColor;
      break;
    case JDStatusBarBackgroundTypePill: {
      JDStatusBarPillStyle *pillStyle = backgroundStyle.pillStyle;
      self.backgroundColor = [UIColor clearColor];
      [self createPillBackgroundViewIfNeeded];
      _pillBackgroundView.backgroundColor = backgroundStyle.backgroundColor;

      // set border
      _pillBackgroundView.layer.borderColor = pillStyle.borderColor.CGColor;
      _pillBackgroundView.layer.borderWidth = pillStyle.borderWidth;

      // set shadows
      _pillBackgroundView.layer.shadowColor = pillStyle.shadowColor.CGColor;
      _pillBackgroundView.layer.shadowRadius = pillStyle.shadowColor ? pillStyle.shadowRadius : 0.0;
      _pillBackgroundView.layer.shadowOpacity = pillStyle.shadowColor ? 1.0 : 0.0;
      _pillBackgroundView.layer.shadowOffset = pillStyle.shadowColor ? pillStyle.shadowOffset : CGSizeZero;
      break;
    }
  }
}

#pragma mark - Layout

static const NSInteger kActivityIndicatorSpacing = 5.0;

static CGRect contentRectForWindow(UIView *view) {
  CGFloat topLayoutMargin = JDStatusBarRootVCLayoutMarginForWindow(view.window).top;
  if (topLayoutMargin == 0) {
    topLayoutMargin = JDStatusBarFrameForWindowScene(view.window.windowScene).size.height;
  }

  CGFloat height = view.bounds.size.height - topLayoutMargin;
  return CGRectMake(0, topLayoutMargin, view.bounds.size.width, height);
}

static CGFloat fittedTextWidthForLabel(UILabel *textLabel) {
  NSDictionary *attributes = @{NSFontAttributeName:textLabel.font};
  return MIN([textLabel.text sizeWithAttributes:attributes].width, CGRectGetWidth(textLabel.frame));
}

- (void)layoutSubviews {
  [super layoutSubviews];

  // text label
  CGFloat labelInsetX = 30.0;
  CGRect contentRect = contentRectForWindow(self);
  _textLabel.frame = CGRectOffset(CGRectInset(contentRect, labelInsetX, 0), 0, _style.textStyle.textOffsetY);

  // background type
  [self layoutSubviewsForBackgroundType];

  // progress view
  if (_progressView && _progressView.layer.animationKeys.count == 0) {
    _progressView.frame = [self progressViewRectForPercentage:_progressBarPercentage];
  }

  // activity indicator
  if (_displaysActivityIndicator) {
    CGRect indicatorFrame = _activityIndicatorView.frame;
    indicatorFrame.origin.y = _textLabel.frame.origin.y + floor((_textLabel.frame.size.height - CGRectGetHeight(indicatorFrame))/2.0);

    // x-position
    CGFloat textWidth = fittedTextWidthForLabel(_textLabel);
    if (textWidth == 0.0) {
      indicatorFrame.origin.x = round(contentRect.size.width/2.0 - indicatorFrame.size.width/2.0);
    } else {
      indicatorFrame.origin.x = round((contentRect.size.width - textWidth)/2.0 - indicatorFrame.size.width - kActivityIndicatorSpacing);
    }

    if (textWidth > 0.0) {
      // adjust centering
      CGFloat centerAdjustement = round((CGRectGetWidth(indicatorFrame) + kActivityIndicatorSpacing) / 2.0);
      _textLabel.frame = CGRectOffset(_textLabel.frame, centerAdjustement, 0);
      _activityIndicatorView.frame = CGRectOffset(indicatorFrame, centerAdjustement, 0);
    } else {
      _activityIndicatorView.frame = indicatorFrame;
    }
  }
}

- (void)layoutSubviewsForBackgroundType {
  switch (_style.backgroundStyle.backgroundType) {
    case JDStatusBarBackgroundTypeClassic: {
      _pillBackgroundView.hidden = YES;
      _progressView.layer.mask = nil;
      break;
    }
    case JDStatusBarBackgroundTypePill: {
      _pillBackgroundView.hidden = NO;
      [self layoutSubviewsForPillBackground];
      break;
    }
  }
}

- (void)layoutSubviewsForPillBackground {
  JDStatusBarPillStyle *pillStyle = _style.backgroundStyle.pillStyle;

  // pill layout parameters
  CGFloat pillHeight = pillStyle.height;
  CGFloat paddingX = 20.0;
  CGFloat minimumPillInset = 20.0;
  CGFloat maximumPillWidth = self.bounds.size.width - minimumPillInset * 2;
  CGFloat minimumPillWidth = MIN(maximumPillWidth, MAX(0.0, pillStyle.minimumWidth));

  // activity indicator padding adjustment
  if (_displaysActivityIndicator) {
    paddingX += round((CGRectGetWidth(_activityIndicatorView.frame) + kActivityIndicatorSpacing) / 2.0);
  }

  // layout pill
  CGRect contentRect = contentRectForWindow(self);
  CGFloat pillWidth = round(MAX(minimumPillWidth, MIN(maximumPillWidth, fittedTextWidthForLabel(_textLabel) + paddingX * 2)));
  CGFloat pillX = round(MAX(minimumPillInset, (CGRectGetWidth(self.bounds) - pillWidth)/2.0));
  CGFloat pillY = round(contentRect.origin.y + contentRect.size.height - pillHeight);
  CGRect pillFrame = CGRectMake(pillX, pillY, pillWidth, pillHeight);
  _pillBackgroundView.frame = pillFrame;

  // layout text label
  _textLabel.frame = CGRectOffset(CGRectInset(pillFrame, paddingX, 0), 0, _style.textStyle.textOffsetY);

  // setup rounded corners (not using a mask layer, so that we can use shadows on this view)
  _pillBackgroundView.layer.cornerRadius = round(_pillBackgroundView.frame.size.height / 2.0);
  _pillBackgroundView.layer.cornerCurve = kCACornerCurveContinuous;
  _pillBackgroundView.layer.allowsEdgeAntialiasing = YES;

  // mask progress to pill size & shape
  _progressView.layer.mask = roundRectMaskForRectAndRadius([_progressView convertRect:pillFrame fromView:self]);
}

static CALayer *roundRectMaskForRectAndRadius(CGRect rect) {
  UIBezierPath *roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CGRectGetHeight(rect) / 2.0];
  CAShapeLayer *maskLayer = [CAShapeLayer layer];
  maskLayer.path = roundedRectPath.CGPath;
  return maskLayer;
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

#pragma mark - HitTest

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  if (self.userInteractionEnabled) {
    switch (_style.backgroundStyle.backgroundType) {
      case JDStatusBarBackgroundTypeClassic:
        return [super hitTest:point withEvent:event];
      case JDStatusBarBackgroundTypePill:
        return [_pillBackgroundView hitTest:[self convertPoint:point toView:_pillBackgroundView] withEvent:event];
    }
  }
  return nil;
}

@end
