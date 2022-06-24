//
//  JDStatusBarView.m
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "JDSBNotificationView.h"

#import "JDStatusBarNotificationStyle.h"
#import "JDSystemStatusBarHelpers.h"

static const NSInteger kExpectedSubviewTag = 12321;

@interface JDSBNotificationView () <UIGestureRecognizerDelegate>
@end

@implementation JDSBNotificationView {
  JDStatusBarNotificationStyle *_style;

  UIView *_contentView;
  UIView *_pillView;
  UIView *_progressView;
  UILabel *_titleLabel;
  UILabel *_subtitleLabel;
  UIActivityIndicatorView *_activityIndicatorView;
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
  titleLabel.adjustsFontSizeToFitWidth = YES;
  _titleLabel = titleLabel;

#if JDSB_LAYOUT_DEBUGGING
  _titleLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
  _titleLabel.layer.borderWidth = 1.0;
#endif

  UILabel *subtitleLabel = [UILabel new];
  subtitleLabel.tag = kExpectedSubviewTag;
  subtitleLabel.backgroundColor = [UIColor clearColor];
  subtitleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
  subtitleLabel.adjustsFontSizeToFitWidth = YES;
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

  _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
  _longPressGestureRecognizer.minimumPressDuration = 0.0;
  _longPressGestureRecognizer.enabled = YES;
  _longPressGestureRecognizer.delegate = self;
  [self addGestureRecognizer:_longPressGestureRecognizer];

  _panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
  _panGestureRecognizer.enabled = YES;
  _panGestureRecognizer.delegate = self;
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
  if (_leftView != _activityIndicatorView) {
    _leftView = nil;
  }

  // ensure expected subviews are set
  [self addSubview:_contentView];
  [_contentView addSubview:_pillView];
  [_contentView addSubview:_progressView];
  [_contentView addSubview:_titleLabel];
  [_contentView addSubview:_subtitleLabel];
  if (_leftView) {
    [_contentView addSubview:_leftView];
  }

  // ensure gesture recognizers are added
  [self addGestureRecognizer:_longPressGestureRecognizer];
  [self addGestureRecognizer:_panGestureRecognizer];
}

#pragma mark - acitivity indicator

- (void)createActivityIndicatorViewIfNeeded {
  if (_activityIndicatorView == nil) {
    _activityIndicatorView = [UIActivityIndicatorView new];
    _activityIndicatorView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [_activityIndicatorView sizeToFit];
    _activityIndicatorView.color = _style.leftViewStyle.tintColor ?: _style.textStyle.textColor;
    _activityIndicatorView.tag = kExpectedSubviewTag;
  }
}

- (BOOL)displaysActivityIndicator {
  return _leftView == _activityIndicatorView;
}

- (void)setDisplaysActivityIndicator:(BOOL)displaysActivityIndicator {
  _activityIndicatorView.hidden = !displaysActivityIndicator;

  if (displaysActivityIndicator) {
    [self createActivityIndicatorViewIfNeeded];
    [_activityIndicatorView startAnimating];
    [self setLeftView:_activityIndicatorView];
  } else {
    [_activityIndicatorView stopAnimating];
    if (_leftView == _activityIndicatorView) {
      [self setLeftView:nil];
    }
  }
}

#pragma mark - progress bar

- (void)createProgressViewIfNeeded {
  if (_progressView == nil) {
    _progressView = [[UIView alloc] initWithFrame:CGRectZero];
    _progressView.backgroundColor = _style.progressBarStyle.barColor;
    _progressView.layer.cornerRadius = _style.progressBarStyle.cornerRadius;
    _progressView.frame = progressViewRectForPercentage(_contentView.bounds, 0.0, _style);
    _progressView.tag = kExpectedSubviewTag;

    [_contentView insertSubview:_progressView belowSubview:_titleLabel];
    [self setNeedsLayout];
  }
}

CGRect progressViewRectForPercentage(CGRect contentRect, CGFloat percentage, JDStatusBarNotificationStyle *style) {
  JDStatusBarNotificationProgressBarStyle *progressBarStyle = style.progressBarStyle;

  // calculate progressView frame
  CGFloat barHeight = MIN(contentRect.size.height, MAX(0.5, progressBarStyle.barHeight));
  CGFloat width = round((contentRect.size.width - 2 * progressBarStyle.horizontalInsets) * percentage);
  CGRect barFrame = CGRectMake(progressBarStyle.horizontalInsets, progressBarStyle.offsetY, width, barHeight);

  // calculate y-position
  switch (progressBarStyle.position) {
    case JDStatusBarNotificationProgressBarPositionTop:
      break;
    case JDStatusBarNotificationProgressBarPositionCenter:
      barFrame.origin.y += style.textStyle.textOffsetY + round((contentRect.size.height - barHeight) / 2.0) + 1;
      break;
    case JDStatusBarNotificationProgressBarPositionBottom:
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
    _progressView.frame = progressViewRectForPercentage(_contentView.bounds, 0.0, _style);
    return;
  }

  // create view & reset state
  [self createProgressViewIfNeeded];
  _progressView.hidden = NO;

  // update progressView frame
  CGRect frame = progressViewRectForPercentage(_contentView.bounds, _progressBarPercentage, _style);

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

#pragma mark - Title

- (NSString *)title {
  return _titleLabel.text;
}

- (void)setTitle:(NSString *)title {
  _titleLabel.accessibilityLabel = title;
  _titleLabel.text = title;
  _titleLabel.hidden = (title.length == 0);

  [self setNeedsLayout];
}

#pragma mark - Subtitle

- (NSString *)subtitle {
  return _subtitleLabel.text;
}

- (void)setSubtitle:(NSString *)subtitle {
  _subtitleLabel.accessibilityLabel = subtitle;
  _subtitleLabel.text = subtitle;
  _subtitleLabel.hidden = (subtitle.length == 0);

  [self setNeedsLayout];
}

#pragma mark - Left View

- (void)setLeftView:(UIView *)leftView {
  [_leftView removeFromSuperview];
  _leftView = leftView;
  if (_style.leftViewStyle.tintColor) {
    _leftView.tintColor = _style.leftViewStyle.tintColor;
  }
  [_contentView addSubview:leftView];
  [self setNeedsLayout];

#if JDSB_LAYOUT_DEBUGGING
  _leftView.layer.borderColor = [UIColor darkGrayColor].CGColor;
  _leftView.layer.borderWidth = 1.0;
#endif
}

#pragma mark - Custom Subview

- (void)setCustomSubview:(UIView *)customSubview {
  [_customSubview removeFromSuperview];
  _customSubview = customSubview;
  [_contentView addSubview:customSubview];
  [self setNeedsLayout];
}

#pragma mark - Style

- (void)setStyle:(JDStatusBarNotificationStyle *)style {
  _style = style;

  // background
  switch (_style.backgroundStyle.backgroundType) {
    case JDStatusBarNotificationBackgroundTypeFullWidth:
      self.backgroundColor = _style.backgroundStyle.backgroundColor;
      _pillView.hidden = YES;
      break;
    case JDStatusBarNotificationBackgroundTypePill: {
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
  _activityIndicatorView.color = _style.leftViewStyle.tintColor ?: _style.textStyle.textColor;
  if (_style.leftViewStyle.tintColor) {
    _leftView.tintColor = _style.leftViewStyle.tintColor;
  }

  // progress view
  _progressView.backgroundColor = style.progressBarStyle.barColor;
  _progressView.layer.cornerRadius = style.progressBarStyle.cornerRadius;

  // enable/disable gesture recognizers
  _panGestureRecognizer.enabled = style.canSwipeToDismiss;
  _longPressGestureRecognizer.enabled = style.canTapToHold;

  [self resetSubviews];
  [self setNeedsLayout];
  [_delegate didUpdateStyle];
}

CGSize sizeFromPoint(CGPoint point) {
  return CGSizeMake(point.x, point.y);
}

void applyTextStyleForLabel(JDStatusBarNotificationTextStyle *textStyle, UILabel *label) {
  label.textColor = textStyle.textColor;
  label.font = textStyle.font;
  if (textStyle.shadowColor != nil) {
    label.shadowColor = textStyle.shadowColor;
    label.shadowOffset = sizeFromPoint(textStyle.shadowOffset);
  } else {
    label.shadowColor = nil;
    label.shadowOffset = CGSizeZero;
  }
}

- (void)setPillStyle:(JDStatusBarNotificationPillStyle *)pillStyle {
  // set border
  _pillView.layer.borderColor = pillStyle.borderColor.CGColor;
  _pillView.layer.borderWidth = pillStyle.borderColor ? pillStyle.borderWidth : 0.0;

  // set shadows
  _pillView.layer.shadowColor = pillStyle.shadowColor.CGColor;
  _pillView.layer.shadowRadius = pillStyle.shadowColor ? pillStyle.shadowRadius : 0.0;
  _pillView.layer.shadowOpacity = pillStyle.shadowColor ? 1.0 : 0.0;
  _pillView.layer.shadowOffset = sizeFromPoint(pillStyle.shadowColor ? pillStyle.shadowOffsetXY : CGPointZero);
}

#pragma mark - Layout

static CGRect contentRectForWindow(UIView *view) {
  CGFloat topLayoutMargins = view.superview.layoutMargins.top;
  if (topLayoutMargins <= 8) {
    // ignore default margins, fallback to system status bar height
    topLayoutMargins = JDStatusBarFrameForWindowScene(view.window.windowScene).size.height;
  }

  CGFloat height = view.bounds.size.height - topLayoutMargins;
  return CGRectMake(0, topLayoutMargins, view.bounds.size.width, height);
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
  JDStatusBarNotificationPillStyle *pillStyle = _style.backgroundStyle.pillStyle;

  // pill layout parameters
  CGFloat pillHeight = pillStyle.height;
  CGFloat paddingX = 20.0;
  CGFloat minimumPillInset = 20.0;
  CGFloat maximumPillWidth = contentRect.size.width - minimumPillInset * 2;
  CGFloat minimumPillWidth = MIN(maximumPillWidth, MAX(pillHeight, pillStyle.minimumWidth));

  // left view padding adjustment
  if (_leftView != nil) {
    paddingX += round((CGRectGetWidth(_leftView.frame) + _style.leftViewStyle.spacing) / 2.0);
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

  // content & pill view
  switch (_style.backgroundStyle.backgroundType) {
    case JDStatusBarNotificationBackgroundTypeFullWidth: {
      _contentView.frame = contentRectForWindow(self);
      break;
    }
    case JDStatusBarNotificationBackgroundTypePill: {
      _contentView.frame = [self pillContentRectForContentRect:contentRectForWindow(self)];
      _pillView.frame = _contentView.bounds;

      // setup rounded corners (not using a mask layer, so that we can use shadows on this view)
      _pillView.layer.cornerRadius = round(_pillView.frame.size.height / 2.0);
      _pillView.layer.cornerCurve = kCACornerCurveContinuous;
      _pillView.layer.allowsEdgeAntialiasing = YES;
      break;
    }
  }

  // custom subview always matches full content view
  _customSubview.frame = _contentView.bounds;

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

  // default to center alignment
  NSTextAlignment textAlignment = NSTextAlignmentCenter;

  // progress view
  if (_progressView && _progressView.layer.animationKeys.count == 0) {
    _progressView.frame = progressViewRectForPercentage(_contentView.bounds, _progressBarPercentage, _style);
  }

  // left view
  if (_leftView != nil) {
    CGRect leftViewFrame = _leftView.frame;

    // fit left view into notification
    if (_leftView != _activityIndicatorView) {
      if (CGRectIsEmpty(leftViewFrame)) {
        leftViewFrame = CGRectMake(0, 0, innerContentRect.size.height, innerContentRect.size.height);
      }
      leftViewFrame.size = [_leftView sizeThatFits:innerContentRect.size];
    }

    // center vertically
    leftViewFrame.origin.y = round((CGRectGetHeight(_contentView.bounds) - CGRectGetHeight(leftViewFrame)) / 2.0 + _style.textStyle.textOffsetY);

    // x-position
    if (combinedMaxTextWidth == 0.0) {
      // center horizontally
      leftViewFrame.origin.x = round(_contentView.bounds.size.width/2.0 - leftViewFrame.size.width/2.0);
    } else {
      switch (_style.leftViewStyle.alignment) {
        case JDStatusBarNotificationLeftViewAlignmentCenterWithText: {
          // position left view in front of text and center together with text
          CGFloat widthAndSpacing = CGRectGetWidth(leftViewFrame) + _style.leftViewStyle.spacing;
          _titleLabel.frame = CGRectOffset(_titleLabel.frame, round(widthAndSpacing / 2.0), 0);
          leftViewFrame.origin.x = MAX(CGRectGetMinX(innerContentRect), CGRectGetMinX(_titleLabel.frame) - widthAndSpacing);
          textAlignment = NSTextAlignmentLeft;
          break;
        }
        case JDStatusBarNotificationLeftViewAlignmentLeft: {
          // left-align left view
          leftViewFrame.origin.x = innerContentRect.origin.x;
          break;
        }
      }
    }

    leftViewFrame = CGRectOffset(leftViewFrame, _style.leftViewStyle.offset.x, _style.leftViewStyle.offset.y);
    _leftView.frame = leftViewFrame;

    // title adjustments
    if (combinedMaxTextWidth > 0.0) {
      CGRect titleRect = _titleLabel.frame;

      // avoid left view/text overlap
      CGRect viewAndSpacing = leftViewFrame;
      viewAndSpacing.size.width += _style.leftViewStyle.spacing;
      CGRect intersection = CGRectIntersection(viewAndSpacing, titleRect);
      if (!CGRectIsNull(intersection)) {
        textAlignment = NSTextAlignmentLeft;
        titleRect.origin.x += CGRectGetWidth(intersection);
      }

      // respect inner bounds
      titleRect.size.width = MIN(titleRect.size.width, CGRectGetMaxX(innerContentRect) - titleRect.origin.x);

      _titleLabel.frame = titleRect;
    }
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

  // update text alignment
  _titleLabel.textAlignment = textAlignment;
  _subtitleLabel.textAlignment = textAlignment;

  // update masks (after layout is done)
  [self setupLayerMasksForPillStyleIfNeeded];
}

- (void)setupLayerMasksForPillStyleIfNeeded {
  // mask progress view & custom subview to pill size & shape
  switch (_style.backgroundStyle.backgroundType) {
    case JDStatusBarNotificationBackgroundTypeFullWidth: {
      _progressView.layer.mask = nil;
      _customSubview.layer.mask = nil;
      break;
    }
    case JDStatusBarNotificationBackgroundTypePill: {
      if (_progressView) {
        _progressView.layer.mask = roundRectMaskForRectAndRadius([_progressView convertRect:_pillView.frame fromView:_pillView.superview]);
      }
      if (_customSubview) {
        _customSubview.layer.mask = roundRectMaskForRectAndRadius([_customSubview convertRect:_pillView.frame fromView:_pillView.superview]);
      }
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

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  return (otherGestureRecognizer == _longPressGestureRecognizer);
}

@end
