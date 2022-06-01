//
//  JDStatusBarView.m
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "JDStatusBarView.h"

#import "JDStatusBarStyle.h"
#import "JDStatusBarLayoutMarginHelper.h"

@implementation JDStatusBarView {
  JDStatusBarStyle *_style;

  CGFloat _textVerticalPositionAdjustment;
  JDStatusBarHeightForIPhoneX _heightForIPhoneX;
}

@synthesize textLabel = _textLabel;
@synthesize activityIndicatorView = _activityIndicatorView;

- (instancetype)initWithStyle:(JDStatusBarStyle *)style {
  self = [super init];
  if (self) {
    [self setupTextLabel];
    [self setStyle:style];
  }
  return self;
}

#pragma mark - dynamic getter

- (void)setupTextLabel {
  _textLabel = [[UILabel alloc] init];
  _textLabel.backgroundColor = [UIColor clearColor];
  _textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
  _textLabel.textAlignment = NSTextAlignmentCenter;
  _textLabel.adjustsFontSizeToFitWidth = YES;
  _textLabel.clipsToBounds = YES;
  [self addSubview:_textLabel];
}

- (UIActivityIndicatorView *)activityIndicatorView {
  if (_activityIndicatorView == nil) {
    _activityIndicatorView = [UIActivityIndicatorView new];
    _activityIndicatorView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [self addSubview:_activityIndicatorView];
  }
  return _activityIndicatorView;
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
  _heightForIPhoneX = style.heightForIPhoneX;

  _textLabel.textColor = style.textColor;
  _textLabel.font = style.font;

  if (style.textShadow != nil) {
    _textLabel.shadowColor = style.textShadow.shadowColor;
    _textLabel.shadowOffset = style.textShadow.shadowOffset;
  } else {
    _textLabel.shadowColor = nil;
    _textLabel.shadowOffset = CGSizeZero;
  }

  [self setNeedsLayout];
}

#pragma mark - layout

- (void)layoutSubviews {
  [super layoutSubviews];

  // label
  CGFloat topLayoutMargin = JDStatusBarRootVCLayoutMarginForWindow(self.window).top;
  CGFloat labelAdjustment = topLayoutMargin;
  if (@available(iOS 13, *)) {
    if (topLayoutMargin == 0 ) {
      labelAdjustment = [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
  }

  CGFloat labelY = _textVerticalPositionAdjustment + labelAdjustment + 1;
  CGFloat height = self.bounds.size.height - labelAdjustment - 1;

  // adjust for IPhoneXHalf style
  if (topLayoutMargin > 0){
    switch (_heightForIPhoneX) {
      case JDStatusBarHeightForIPhoneXHalf:
        labelY -= 12;
        height += 9.0;
        break;
      case JDStatusBarHeightForIPhoneXFullNavBar:
        break;
    }
  }

  self.textLabel.frame = CGRectMake(0, labelY, self.bounds.size.width, height);

  // activity indicator
  if (_activityIndicatorView ) {
    NSDictionary *attributes = @{NSFontAttributeName:self.textLabel.font};
    CGSize textSize = [self.textLabel.text sizeWithAttributes:attributes];
    CGRect indicatorFrame = _activityIndicatorView.frame;
    indicatorFrame.origin.x = round((self.bounds.size.width - textSize.width)/2.0) - indicatorFrame.size.width - 16.0;
    indicatorFrame.origin.y = labelY + 1 + floor((CGRectGetHeight(self.textLabel.bounds) - CGRectGetHeight(indicatorFrame))/2.0);
    _activityIndicatorView.frame = indicatorFrame;
  }
}

@end
