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

@property (nonatomic, strong, readonly, nonnull) UILabel *textLabel;
@property (nonatomic, strong, readonly, nullable) UIActivityIndicatorView *activityIndicatorView;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithStyle:(JDStatusBarStyle *)style;

/// Sets the text of the label
- (void)setStatus:(NSString *)status;

/// Styles the view according to the provided style
- (void)setStyle:(JDStatusBarStyle *)style;

/// Ensures the subviews are set, as expected
- (void)resetSubviewsIfNeeded;

@end

NS_ASSUME_NONNULL_END
