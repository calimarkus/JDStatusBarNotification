//
//  JDStatusBarView.h
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JDStatusBarStyle;

@protocol JDStatusBarViewDelegate <NSObject>
- (void)statusBarViewDidPanToDismiss;
- (void)didUpdateStyle;
@end

@interface JDStatusBarView : UIView

@property (nonatomic, weak, nullable) id<JDStatusBarViewDelegate> delegate;

@property (nonatomic, strong, nonnull) NSString *text;
@property (nonatomic, strong, nonnull) JDStatusBarStyle *style;

@property (nonatomic, strong, readonly, nonnull) UILabel *textLabel;
@property (nonatomic, strong, readonly, nonnull) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, assign) BOOL displaysActivityIndicator;
@property (nonatomic, assign) CGFloat progressBarPercentage;

/// The custom subview will be layouted according to the selected style (as well as the current device state like rotation, status bar visibility, etc..)
/// It won't overlap the statusbar (if visible). It covers the full width of the screen. The height is defined by the selected style.
@property (nonatomic, strong, nullable) UIView *customSubview;

- (void)animateProgressBarToPercentage:(CGFloat)percentage
                     animationDuration:(CGFloat)animationDuration
                            completion:(void(^ _Nullable)(void))completion;

- (void)resetSubviewsIfNeeded;

// designated initializer
- (instancetype)initWithStyle:(JDStatusBarStyle *)style;

// default init unavailable
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
