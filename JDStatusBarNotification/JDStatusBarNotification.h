//
//  JDStatusBarNotification.h
//
//  Based on KGStatusBar by Kevin Gibbon
//
//  Created by Markus Emrich on 10/28/13.
//  Copyright 2013 Markus Emrich. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const JDStatusBarStyleError;   /// This style has a red background with a white Helvetica label.
extern NSString *const JDStatusBarStyleWarning; /// This style has a yellow background with a gray Helvetica label.
extern NSString *const JDStatusBarStyleSuccess; /// This style has a green background with a white Helvetica label.

typedef NS_ENUM(NSInteger, JDStatusBarAnimationType) {
    JDStatusBarAnimationTypeMove, /// Notification will move in from the top, and hide again to the top
    JDStatusBarAnimationTypeFade  /// Notification will fade in and out
};

@class JDStatusBarStyle;
typedef JDStatusBarStyle*(^JDPrepareStyleBlock)(JDStatusBarStyle *style);

/**
 *  This class is a singletion which is used to present notifications 
 *  on top of the status bar. To present a notification, use one of the
 *  given class methods.
 */
@interface JDStatusBarNotification : UIView

/**
 *  Show a notification. It won't hide automatically, 
 *  you have to dimiss it on your own.
 *
 *  @param status The message to display
 */
+ (void)showWithStatus:(NSString *)status;

/**
 *  Show a notification with a specific style. It won't 
 *  hide automatically, you have to dimiss it on your own.
 *
 *  @param status The message to display
 *  @param styleName The name of the style. You can use any JDStatusBarStyle, 
 *  or a custom style, after you added one. If this is nil, the default style will be used.
 */
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


