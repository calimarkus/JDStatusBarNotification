//
//  JDStatusBarView.m
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "JDStatusBarView.h"

#import "JDStatusBarStyle.h"
#import "JDStatusBarLayoutMarginHelper.h"
#import "JDStatusBarManagerHelper.h"

static const NSInteger kExpectedSubviewTag = 12321;

@implementation JDStatusBarView {
  JDStatusBarStyle *_style;

  UIView *_contentView;
  UIView *_pillView;
  UIView *_progressView;
  UILabel *_titleLabel;
  UILabel *_subtitleLabel;
  UIActivityIndicatorView *_activityIndicatorView;

  UIPanGestureRecognizer *_panGestureRecognizer;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setupView];
  }
  return self;
}

#pragma mark - view setup

- (void)setupView {
  UILabel *titleLabel = [UILabel new];
  titleLabel.tag = kExpectedSubviewTag;
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.adjustsFontSizeToFitWidth = YES;
  titleLabel.clipsToBounds = YES;
  _titleLabel = titleLabel;

#if JDSB_LAYOUT_DEBUGGING
  _titleLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
  _titleLabel.layer.borderWidth = 1.0;
#endif

  UILabel *subtitleLabel = [UILabel new];
  subtitleLabel.tag = kExpectedSubviewTag;
  subtitleLabel.backgroundColor = [UIColor clearColor];
  subtitleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
  subtitleLabel.textAlignment = NSTextAlignmentCenter;
  subtitleLabel.adjustsFontSizeToFitWidth = YES;
  subtitleLabel.clipsToBounds = YES;
  _subtitleLabel = subtitleLabel;

#if JDSB_LAYOUT_DEBUGGING
  _subtitleLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
  _subtitleLabel.layer.borderWidth = 1.0;
#endif

  UIView *pillView = [[UIView alloc] initWithFrame:CGRectZero];
  pillView.backgroundColor = [UIColor clearColor];
  pillView.tag = kExpectedSubviewTag;
  _pillView = pillView;

  UIView *contentView = [UIView new];
  contentView.tag = kExpectedSubviewTag;
  _contentView = contentView;

  _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
  _panGestureRecognizer.enabled = YES;
  [self addGestureRecognizer:_panGestureRecognizer];
}

- (void)resetSubviews {
  // remove subviews added from outside
  for (UIView *view in [NSArray arrayWithObjects:self, _contentView, _titleLabel, _subtitleLabel, _pillView, nil]) {
    for (UIView *subview in view.subviews) {
      if (subview.tag != kExpectedSubviewTag) {
        [subview removeFromSuperview];
      }
    }
  }

  // reset custom subview
  _customSubview = nil;

  // ensure expected subviews are set
  [self addSubview:_contentView];
  [_contentView addSubview:_pillView];
  [_contentView addSubview:_progressView];
  [_contentView addSubview:_titleLabel];
  [_contentView addSubview:_subtitleLabel];
  [_contentView addSubview:_activityIndicatorView];

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

    [_contentView addSubview:_activityIndicatorView];
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

  _titleLabel.textAlignment = _displaysActivityIndicator ? NSTextAlignmentLeft : NSTextAlignmentCenter;
  _subtitleLabel.textAlignment = _titleLabel.textAlignment;

  _activityIndicatorView.hidden = !displaysActivityIndicator;
  [self setNeedsLayout];
}

#pragma mark - progress bar

- (void)createProgressViewIfNeeded {
  if (_progressView == nil) {
    _progressView = [[UIView alloc] initWithFrame:CGRectZero];
    _progressView.backgroundColor = _style.progressBarStyle.barColor;
    _progressView.layer.cornerRadius = _style.progressBarStyle.cornerRadius;
    _progressView.frame = [self progressViewRectForPercentage:0.0];
    _progressView.tag = kExpectedSubviewTag;

    [_contentView insertSubview:_progressView belowSubview:_titleLabel];
    [self setNeedsLayout];
  }
}

- (CGRect)progressViewRectForPercentage:(CGFloat)percentage {
  JDStatusBarProgressBarStyle *progressBarStyle = _style.progressBarStyle;

  // calculate progressView frame
  CGRect contentRect = _contentView.bounds;
  CGFloat barHeight = MIN(contentRect.size.height, MAX(0.5, progressBarStyle.barHeight));
  CGFloat width = round((contentRect.size.width - 2 * progressBarStyle.horizontalInsets) * percentage);
  CGRect barFrame = CGRectMake(progressBarStyle.horizontalInsets, progressBarStyle.offsetY, width, barHeight);

  // calculate y-position
  switch (_style.progressBarStyle.position) {
    case JDStatusBarProgressBarPositionTop:
      break;
    case JDStatusBarProgressBarPositionCenter:
      barFrame.origin.y += _style.textStyle.textOffsetY + round((contentRect.size.height - barHeight) / 2.0) + 1;
      break;
    case JDStatusBarProgressBarPositionBottom:
      barFrame.origin.y += contentRect.size.height - barHeight;
      break;
  }

  return barFrame;
}

- (void)setProgressBarPercentage:(CGFloat)percentage {
  [self animateProgressBarToPercentage:percentage animationDuration:0.0 completion:nil];
}

- (void)animateProgressBarToPercentage:(CGFloat)percentage
                     animationDuration:(CGFloat)animationDuration
                            completion:(void(^ _Nullable)(void))completion {
  // clamp progress
  _progressBarPercentage = MIN(1.0, MAX(0.0, percentage));

  // reset animations
  [_progressView.layer removeAllAnimations];

  // reset view
  if (_progressBarPercentage == 0.0 && animationDuration == 0.0) {
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

#pragma mark - Text

- (NSString *)title {
  return _titleLabel.text;
}

- (void)setTitle:(NSString *)title {
  _titleLabel.accessibilityLabel = title;
  _titleLabel.text = title;

  [self setNeedsLayout];
}

- (NSString *)subtitle {
  return _subtitleLabel.text;
}

- (void)setSubtitle:(NSString *)subtitle {
  _subtitleLabel.accessibilityLabel = subtitle;
  _subtitleLabel.text = subtitle;

  [self setNeedsLayout];
}

#pragma mark - Style

- (void)setStyle:(JDStatusBarStyle *)style {
  _style = style;

  // background
  switch (_style.backgroundStyle.backgroundType) {
    case JDStatusBarBackgroundTypeFullWidth:
      self.backgroundColor = _style.backgroundStyle.backgroundColor;
      _pillView.hidden = YES;
      break;
    case JDStatusBarBackgroundTypePill: {
      self.backgroundColor = [UIColor clearColor];
      _pillView.backgroundColor = _style.backgroundStyle.backgroundColor;
      _pillView.hidden = NO;
      [self setPillStyle:style.backgroundStyle.pillStyle];
      break;
    }
  }

  // style labels
  applyTextStyleForLabel(style.textStyle, _titleLabel);
  applyTextStyleForLabel(style.subtitleStyle, _subtitleLabel);

  // activity indicator
  _activityIndicatorView.color = style.textStyle.textColor;

  // progress view
  _progressView.backgroundColor = style.progressBarStyle.barColor;
  _progressView.layer.cornerRadius = style.progressBarStyle.cornerRadius;

  // enable/disable gesture recognizer
  _panGestureRecognizer.enabled = style.canSwipeToDismiss;

  [self resetSubviews];
  [self setNeedsLayout];
  [_delegate didUpdateStyle];
}

void applyTextStyleForLabel(JDStatusBarTextStyle *textStyle, UILabel *label) {
  label.textColor = textStyle.textColor;
  label.font = textStyle.font;
  if (textStyle.textShadowColor != nil) {
    label.shadowColor = textStyle.textShadowColor;
    label.shadowOffset = textStyle.textShadowOffset;
  } else {
    label.shadowColor = nil;
    label.shadowOffset = CGSizeZero;
  }
}

- (void)setPillStyle:(JDStatusBarPillStyle *)pillStyle {
  // set border
  _pillView.layer.borderColor = pillStyle.borderColor.CGColor;
  _pillView.layer.borderWidth = pillStyle.borderColor ? pillStyle.borderWidth : 0.0;

  // set shadows
  _pillView.layer.shadowColor = pillStyle.shadowColor.CGColor;
  _pillView.layer.shadowRadius = pillStyle.shadowColor ? pillStyle.shadowRadius : 0.0;
  _pillView.layer.shadowOpacity = pillStyle.shadowColor ? 1.0 : 0.0;
  _pillView.layer.shadowOffset = pillStyle.shadowColor ? pillStyle.shadowOffset : CGSizeZero;
}

#pragma mark - Custom Subview

- (void)setCustomSubview:(UIView *)customSubview {
  [_customSubview removeFromSuperview];
  _customSubview = customSubview;
  [_contentView addSubview:_customSubview];
  [self setNeedsLayout];
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

static CGSize realTextSizeForLabel(UILabel *textLabel) {
  NSDictionary *attributes = @{NSFontAttributeName:textLabel.font};
  return [textLabel.text sizeWithAttributes:attributes];
}

static CALayer *roundRectMaskForRectAndRadius(CGRect rect) {
  UIBezierPath *roundedRectPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:CGRectGetHeight(rect) / 2.0];
  CAShapeLayer *maskLayer = [CAShapeLayer layer];
  maskLayer.path = roundedRectPath.CGPath;
  return maskLayer;
}

- (CGRect)pillContentRectForContentRect:(CGRect)contentRect {
  JDStatusBarPillStyle *pillStyle = _style.backgroundStyle.pillStyle;

  // pill layout parameters
  CGFloat pillHeight = pillStyle.height;
  CGFloat paddingX = 20.0;
  CGFloat minimumPillInset = 20.0;
  CGFloat maximumPillWidth = contentRect.size.width - minimumPillInset * 2;
  CGFloat minimumPillWidth = MIN(maximumPillWidth, MAX(0.0, pillStyle.minimumWidth));

  // activity indicator padding adjustment
  if (_displaysActivityIndicator) {
    paddingX += round((CGRectGetWidth(_activityIndicatorView.frame) + kActivityIndicatorSpacing) / 2.0);
  }

  // layout pill
  CGFloat maxTextWidth = MAX(realTextSizeForLabel(_titleLabel).width, realTextSizeForLabel(_subtitleLabel).width);
  CGFloat pillWidth = round(MAX(minimumPillWidth, MIN(maximumPillWidth, maxTextWidth + paddingX * 2)));
  CGFloat pillX = round(MAX(minimumPillInset, (CGRectGetWidth(self.bounds) - pillWidth)/2.0));
  CGFloat pillY = round(contentRect.origin.y + contentRect.size.height - pillHeight);
  return CGRectMake(pillX, pillY, pillWidth, pillHeight);
}

- (void)layoutSubviews {
  [super layoutSubviews];

  // content view
  switch (_style.backgroundStyle.backgroundType) {
    case JDStatusBarBackgroundTypeFullWidth:
      _contentView.frame = contentRectForWindow(self);
      [self resetPillViewLayerAndMasks];
      break;
    case JDStatusBarBackgroundTypePill:
      _contentView.frame = [self pillContentRectForContentRect:contentRectForWindow(self)];
      _pillView.frame = _contentView.bounds;
      [self stylePillViewLayerAndMasksForNewBounds];
      break;
  }

  // title label
  CGFloat labelInsetX = 20.0;
  CGFloat subtitleSpacing = 1.0;
  CGRect innerContentRect = CGRectInset(_contentView.bounds, labelInsetX, 0);
  CGSize titleSize = realTextSizeForLabel(_titleLabel);
  CGFloat titleWidth = MIN(titleSize.width, CGRectGetWidth(innerContentRect));
  CGSize subtitleSize = realTextSizeForLabel(_subtitleLabel);
  CGFloat subtitleWidth = MIN(subtitleSize.width, CGRectGetWidth(innerContentRect));
  CGFloat combinedMaxTextWidth = MAX(titleWidth, subtitleWidth);
  _titleLabel.frame = CGRectMake(round((CGRectGetWidth(_contentView.bounds) - combinedMaxTextWidth) / 2.0),
                                 round((CGRectGetHeight(_contentView.bounds) - titleSize.height) / 2.0 + _style.textStyle.textOffsetY),
                                 combinedMaxTextWidth,
                                 titleSize.height);

  // custom subview
  _customSubview.frame = _contentView.bounds;

  // progress view
  if (_progressView && _progressView.layer.animationKeys.count == 0) {
    _progressView.frame = [self progressViewRectForPercentage:_progressBarPercentage];
  }

  // activity indicator
  if (_displaysActivityIndicator) {
    CGRect indicatorFrame = _activityIndicatorView.frame;
    indicatorFrame.origin.y = _titleLabel.frame.origin.y + floor((_titleLabel.frame.size.height - CGRectGetHeight(indicatorFrame))/2.0);

    // x-position
    if (titleWidth == 0.0) {
      // simply center
      indicatorFrame.origin.x = round(_contentView.bounds.size.width/2.0 - indicatorFrame.size.width/2.0);
    } else {
      CGFloat centerXAdjustement = round((CGRectGetWidth(indicatorFrame) + kActivityIndicatorSpacing) / 2.0);

      // position in front of text
      indicatorFrame.origin.x = CGRectGetMinX(_titleLabel.frame) - CGRectGetWidth(indicatorFrame) - kActivityIndicatorSpacing + centerXAdjustement;

      // adjust text label
      CGRect textRect = _titleLabel.frame;
      textRect.origin.x += centerXAdjustement;

      // maintain max-bounds
      CGFloat diffLeft = indicatorFrame.origin.x - CGRectGetMinX(innerContentRect);
      if (diffLeft < 0.0) {
        indicatorFrame.origin.x = CGRectGetMinX(innerContentRect);
        textRect.origin.x += ABS(diffLeft);
      }
      CGFloat diffRight = CGRectGetMaxX(innerContentRect) - CGRectGetMaxX(textRect);
      if (diffRight < 0.0) {
        textRect.size.width -= ABS(diffRight);
      }

      // adjust text
      _titleLabel.frame = textRect;
    }

    _activityIndicatorView.frame = indicatorFrame;
  }

  // subtitle label
  if (_subtitleLabel.text.length > 0) {
    // adjust title y centering
    CGFloat centerYAdjustement = round((subtitleSize.height + subtitleSpacing) / 2.0);
    _titleLabel.frame = CGRectOffset(_titleLabel.frame, 0, -centerYAdjustement);

    // set subtitle frame
    _subtitleLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame),
                                      CGRectGetMaxY(_titleLabel.frame) + subtitleSpacing + _style.subtitleStyle.textOffsetY,
                                      CGRectGetWidth(_titleLabel.frame),
                                      subtitleSize.height);
  }
}

- (void)resetPillViewLayerAndMasks {
  _progressView.layer.mask = nil;
  _customSubview.layer.mask = nil;
}

- (void)stylePillViewLayerAndMasksForNewBounds {
  // setup rounded corners (not using a mask layer, so that we can use shadows on this view)
  _pillView.layer.cornerRadius = round(_pillView.frame.size.height / 2.0);
  _pillView.layer.cornerCurve = kCACornerCurveContinuous;
  _pillView.layer.allowsEdgeAntialiasing = YES;

  // mask progress to pill size & shape
  if (_progressView) {
    _progressView.layer.mask = roundRectMaskForRectAndRadius([_progressView convertRect:_pillView.frame fromView:_pillView.superview]);
  }
  if (_customSubview) {
    _customSubview.layer.mask = roundRectMaskForRectAndRadius([_customSubview convertRect:_pillView.frame fromView:_pillView.superview]);
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

#pragma mark - HitTest

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  if (self.userInteractionEnabled) {
    return [_contentView hitTest:[self convertPoint:point toView:_contentView] withEvent:event];
  }
  return nil;
}

@end
