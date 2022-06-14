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

@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) NSString *subtitle;
@property (nonatomic, strong, nonnull) JDStatusBarStyle *style;

@property (nonatomic, assign) BOOL displaysActivityIndicator;
@property (nonatomic, assign) CGFloat progressBarPercentage;

/// The custom subview will be layouted according to the selected style (as well as the current device
/// state like rotation, status bar visibility, etc..) It never overlaps the statusbar. The height & width is defined
/// by the selected style. In the pill style the view will match the pill size.
@property (nonatomic, strong, nullable) UIView *customSubview;

- (void)animateProgressBarToPercentage:(CGFloat)percentage
                     animationDuration:(CGFloat)animationDuration
                            completion:(void(^ _Nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
