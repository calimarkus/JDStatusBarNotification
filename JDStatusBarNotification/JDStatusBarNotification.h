//
//  JDStatusBarNotification.h
//
//  Based on KGStatusBar by Kevin Gibbon
//
//  Created by Markus Emrich on 10/28/13.
//  Copyright 2013 Markus Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    JDStatusBarAnimationTypeMove,
    JDStatusBarAnimationTypeFade
} JDStatusBarAnimationType;

@class JDStatusBarStyle;
typedef JDStatusBarStyle*(^JDPrepareStyleBlock)(JDStatusBarStyle *style);

@interface JDStatusBarNotification : UIView

+ (void)showWithStatus:(NSString *)status;
+ (void)showWithStatus:(NSString *)status
             styleName:(NSString*)styleName;

+ (void)showWithStatus:(NSString *)status
          dismissAfter:(NSTimeInterval)timeInterval;
+ (void)showWithStatus:(NSString *)status
          dismissAfter:(NSTimeInterval)timeInterval
             styleName:(NSString*)styleName;

+ (void)dismiss;
+ (void)dismissAfter:(NSTimeInterval)delay;

+ (void)setDefaultStyle:(JDPrepareStyleBlock)prepareBlock;
+ (NSString*)addStyleNamed:(NSString*)identifier
                   prepare:(JDPrepareStyleBlock)prepareBlock;

@end

@interface JDStatusBarStyle : NSObject <NSCopying>
@property (nonatomic, strong) UIColor *barColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) JDStatusBarAnimationType animationType;
@end


