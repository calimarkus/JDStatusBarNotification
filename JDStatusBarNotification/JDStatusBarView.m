//
//  JDStatusBarView.m
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "JDStatusBarView.h"
#import "JDStatusBarLayoutMarginHelper.h"

@interface JDStatusBarView ()
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation JDStatusBarView

#pragma mark - dynamic getter

- (UILabel *)textLabel;
{
  if (_textLabel == nil) {
    _textLabel = [[UILabel alloc] init];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.adjustsFontSizeToFitWidth = YES;
    _textLabel.clipsToBounds = YES;
    [self addSubview:_textLabel];
  }
  return _textLabel;
}

- (UIActivityIndicatorView *)activityIndicatorView;
{
  if (_activityIndicatorView == nil) {
    _activityIndicatorView = [UIActivityIndicatorView new];
    _activityIndicatorView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [self addSubview:_activityIndicatorView];
  }
  return _activityIndicatorView;
}

#pragma mark - setter

- (void)setTextVerticalPositionAdjustment:(CGFloat)textVerticalPositionAdjustment;
{
  _textVerticalPositionAdjustment = textVerticalPositionAdjustment;
  [self setNeedsLayout];
}

#pragma mark - layout

- (void)layoutSubviews;
{
  [super layoutSubviews];

  // label
  CGFloat topLayoutMargin = JDStatusBarRootVCLayoutMarginForWindow(self.window).top;
  CGFloat labelAdjustment = topLayoutMargin;
  if (@available(iOS 13, *)) {
    if (topLayoutMargin == 0 ) {
      labelAdjustment = [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
  }

  CGFloat labelY = self.textVerticalPositionAdjustment + labelAdjustment + 1;
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
