//
//  JDStatusBarView_Private.h
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JDStatusBarViewDelegate <NSObject>
- (void)statusBarViewDidPanToDismiss;
- (void)didUpdateStyle;
@end

@interface JDStatusBarView ()

@property (nonatomic, weak, nullable) id<JDStatusBarViewDelegate> delegate;

- (instancetype)initWithStyle:(JDStatusBarStyle *)style;

- (void)resetSubviewsIfNeeded;

@end

NS_ASSUME_NONNULL_END
