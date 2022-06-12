//
//  JDStatusBarView.h
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JDStatusBarStyle;

@interface JDStatusBarView : UIView

@property (nonatomic, strong, nonnull) NSString *text;
@property (nonatomic, strong, nonnull) JDStatusBarStyle *style;

@property (nonatomic, strong, readonly, nonnull) UILabel *textLabel;
@property (nonatomic, strong, readonly, nonnull) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) BOOL displaysActivityIndicator;
@property (nonatomic, assign) CGFloat progressBarPercentage;

- (void)animateProgressBarToPercentage:(CGFloat)percentage
                     animationDuration:(CGFloat)animationDuration
                            completion:(void(^ _Nullable)(void))completion;

/// Set a custom view, which will be correctly layouted according to the selected style & the current device state (rotation, status bar visibility, etc.)
@property (nonatomic, strong, nullable) UIView *customSubview;

// default init unavailable
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
