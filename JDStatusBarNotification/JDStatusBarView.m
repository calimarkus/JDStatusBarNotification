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
  JDStatusBarStyle *_style;

  CGFloat _textVerticalPositionAdjustment;
}

@synthesize textLabel = _textLabel;
@synthesize panGestureRecognizer = _panGestureRecognizer;
@synthesize activityIndicatorView = _activityIndicatorView;

- (instancetype)initWithStyle:(JDStatusBarStyle *)style {
  self = [super init];
  if (self) {
    [self setupTextLabel];
    [self setupPanGesture];
    [self setStyle:style];
  }
  return self;
}

#pragma mark - view setup

- (void)setupTextLabel {
  _textLabel = [[UILabel alloc] init];
  _textLabel.backgroundColor = [UIColor clearColor];
  _textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
  _textLabel.textAlignment = NSTextAlignmentCenter;
  _textLabel.adjustsFontSizeToFitWidth = YES;
  _textLabel.clipsToBounds = YES;
  [self addSubview:_textLabel];
}

- (void)setupPanGesture {
  _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
  _panGestureRecognizer.enabled = YES;
  [self addGestureRecognizer:_panGestureRecognizer];
}

- (UIActivityIndicatorView *)activityIndicatorView {
  if (_activityIndicatorView == nil) {
    _activityIndicatorView = [UIActivityIndicatorView new];
    _activityIndicatorView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [self addSubview:_activityIndicatorView];
  }
  return _activityIndicatorView;
}

- (void)resetSubviewsIfNeeded {
  // remove subviews added from outside
  for (UIView *subview in self.subviews) {
    if (subview != _textLabel && subview != _activityIndicatorView) {
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

  // ensure pan recognizer is setup
  _panGestureRecognizer.enabled = YES;
  [self addGestureRecognizer:_panGestureRecognizer];
}

#pragma mark - setter

- (void)setStatus:(NSString *)status {
  _textLabel.accessibilityLabel = status;
  _textLabel.text = status;
  
  [self setNeedsLayout];
}

- (void)setStyle:(JDStatusBarStyle *)style {
  _style = style;
  
  self.backgroundColor = style.barColor;
  
  _textVerticalPositionAdjustment = style.textVerticalPositionAdjustment;
  
  _textLabel.textColor = style.textColor;
  _textLabel.font = style.font;
  
  if (style.textShadow != nil) {
    _textLabel.shadowColor = style.textShadow.shadowColor;
    _textLabel.shadowOffset = style.textShadow.shadowOffset;
  } else {
    _textLabel.shadowColor = nil;
    _textLabel.shadowOffset = CGSizeZero;
  }

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
  
  CGFloat labelY = _textVerticalPositionAdjustment + labelAdjustment + 1;
  CGFloat height = self.bounds.size.height - labelAdjustment - 1;
  
  self.textLabel.frame = CGRectMake(0, labelY, self.bounds.size.width, height);
  
  // activity indicator
  if (_activityIndicatorView) {
    NSDictionary *attributes = @{NSFontAttributeName:self.textLabel.font};
    CGSize textSize = [self.textLabel.text sizeWithAttributes:attributes];
    CGRect indicatorFrame = _activityIndicatorView.frame;
    indicatorFrame.origin.x = round((self.bounds.size.width - textSize.width)/2.0) - indicatorFrame.size.width - 16.0;
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
