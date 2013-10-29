//
//  JDStatusBarNotification.m
//
//  Based on KGStatusBar by Kevin Gibbon
//
//  Created by Markus Emrich on 10/28/13.
//  Copyright 2013 Markus Emrich. All rights reserved.
//

#import "JDStatusBarNotification.h"

@interface JDStatusBarNotification ()
@property (nonatomic, strong, readonly) UIWindow *overlayWindow;
@property (nonatomic, strong, readonly) UIView *topBar;
@property (nonatomic, strong, readonly) UILabel *textLabel;

@property (nonatomic, weak) JDStatusBarStyle *activeStyle;
@property (nonatomic, strong) JDStatusBarStyle *defaultStyle;
@property (nonatomic, strong) NSMutableDictionary *userStyles;
@end

@implementation JDStatusBarNotification

@synthesize overlayWindow = _overlayWindow;
@synthesize textLabel = _textLabel;
@synthesize topBar = _topBar;

#pragma mark class methods

+ (JDStatusBarNotification*)sharedInstance {
    static dispatch_once_t once;
    static JDStatusBarNotification *sharedInstance;
    dispatch_once(&once, ^ {
        sharedInstance = [[JDStatusBarNotification alloc] initWithFrame:
                          [[UIScreen mainScreen] bounds]];
        
        // set defaults
        JDStatusBarStyle *defaultStyle = [[JDStatusBarStyle alloc] init];
        defaultStyle.barColor = [UIColor whiteColor];
        defaultStyle.textColor = [UIColor grayColor];
        defaultStyle.font = [UIFont systemFontOfSize:12.0];
        defaultStyle.animationType = JDStatusBarAnimationTypeMove;
        sharedInstance.defaultStyle = defaultStyle;
        
        // prepare userStyles
        sharedInstance.userStyles = [NSMutableDictionary dictionary];
    });
    return sharedInstance;
}

+ (void)showWithStatus:(NSString *)status;
{
    [[self sharedInstance] showWithStatus:status
                                styleName:nil];
}

+ (void)showWithStatus:(NSString *)status
             styleName:(NSString*)styleName;
{
    [[self sharedInstance] showWithStatus:status
                                styleName:styleName];
}

+ (void)showWithStatus:(NSString *)status
          dismissAfter:(NSTimeInterval)timeInterval;
{
    [self showWithStatus:status
            dismissAfter:timeInterval
               styleName:nil];
}

+ (void)showWithStatus:(NSString *)status
          dismissAfter:(NSTimeInterval)timeInterval
             styleName:(NSString*)styleName;
{
    [self showWithStatus:status
               styleName:styleName];
    [self dismissAfter:timeInterval];
}

+ (void)dismiss;
{
    [[JDStatusBarNotification sharedInstance] dismiss];
}

+ (void)dismissAfter:(NSTimeInterval)delay;
{
    [JDStatusBarNotification performSelector:@selector(dismiss)
                                  withObject:self afterDelay:delay];
}

+ (void)setDefaultStyle:(JDPrepareStyleBlock)prepareBlock;
{
    NSAssert(prepareBlock != nil, @"No prepareBlock provided");
    
    JDStatusBarStyle *style = [[self sharedInstance].defaultStyle copy];
    [JDStatusBarNotification sharedInstance].defaultStyle = prepareBlock(style);
}

+ (NSString*)addStyleNamed:(NSString*)identifier
                   prepare:(JDPrepareStyleBlock)prepareBlock;
{
    NSAssert(identifier != nil, @"No identifier provided");
    NSAssert(prepareBlock != nil, @"No prepareBlock provided");
    
    JDStatusBarStyle *style = [[self sharedInstance].defaultStyle copy];
    [[self sharedInstance].userStyles setObject:prepareBlock(style) forKey:identifier];
    return identifier;
}

#pragma mark implementation

- (id)initWithFrame:(CGRect)frame;
{
	
    if ((self = [super initWithFrame:frame])) {
		self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
		self.alpha = 0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)showWithStatus:(NSString *)status
             styleName:(NSString*)styleName;
{
    JDStatusBarStyle *style = nil;
    if (styleName != nil) {
        style = self.userStyles[styleName];
    }
    
    if (style != nil) {
        [self showWithStatus:status style:style];
    } else {
        [self showWithStatus:status style:self.defaultStyle];
    }
}

- (void)showWithStatus:(NSString *)status
                 style:(JDStatusBarStyle*)style;
{
    if (style != self.activeStyle) {
        self.activeStyle = style;
        if (self.activeStyle.animationType == JDStatusBarAnimationTypeFade) {
            self.topBar.alpha = 0.0;
            self.topBar.frame = CGRectMake(0, 0, self.overlayWindow.frame.size.width, [self statusBarHeight]);
        } else {
            self.topBar.alpha = 1.0;
            self.topBar.frame = CGRectMake(0, -[self statusBarHeight], self.overlayWindow.frame.size.width, [self statusBarHeight]);
        }
    }
    
    [self.overlayWindow addSubview:self];
    [self.overlayWindow setHidden:NO];
    
    self.topBar.backgroundColor = style.barColor;
    self.textLabel.textColor = style.textColor;
    self.textLabel.font = style.font;
    self.textLabel.frame = CGRectMake(0, 2, self.topBar.bounds.size.width, self.topBar.bounds.size.height-2);
    self.textLabel.text = status;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.topBar.alpha = 1.0;
        self.topBar.frame = CGRectMake(0, 0, self.overlayWindow.frame.size.width, [self statusBarHeight]);
    }];
    [self setNeedsDisplay];
}

- (void)dismiss;
{
    [UIView animateWithDuration:0.4 animations:^{
        if (self.activeStyle.animationType == JDStatusBarAnimationTypeFade) {
            self.topBar.alpha = 0.0;
        } else {
            self.topBar.frame = CGRectMake(0, -[self statusBarHeight],
                                           self.overlayWindow.frame.size.width, [self statusBarHeight]);
        }
    } completion:^(BOOL finished) {
        [self.topBar removeFromSuperview];
        _topBar = nil;
        _textLabel = nil;
        
        [self.overlayWindow removeFromSuperview];
        _overlayWindow = nil;
    }];
}

#pragma mark helper

- (CGFloat)statusBarHeight;
{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

#pragma mark lazy views

- (UIWindow *)overlayWindow;
{
    if(_overlayWindow == nil) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.userInteractionEnabled = NO;
        _overlayWindow.windowLevel = UIWindowLevelStatusBar;
    }
    return _overlayWindow;
}

- (UIView *)topBar;
{
    if(_topBar == nil) {
        _topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.overlayWindow.frame.size.width, [self statusBarHeight])];
        _topBar.clipsToBounds = YES;
        _topBar.alpha = 0.0;
        [self.topBar addSubview:self.textLabel];
        [self.overlayWindow addSubview:_topBar];
        
        if (self.defaultStyle.animationType == JDStatusBarAnimationTypeMove) {
            self.topBar.alpha = 1.0;
            self.topBar.frame = CGRectMake(0, -[self statusBarHeight],
                                           self.overlayWindow.frame.size.width, [self statusBarHeight]);
        }
    }
    return _topBar;
}

- (UILabel *)textLabel;
{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _textLabel.textAlignment = NSTextAlignmentCenter;
		_textLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    return _textLabel;
}

@end

@implementation JDStatusBarStyle

- (instancetype)copyWithZone:(NSZone *)zone;
{
    JDStatusBarStyle *style = [[[self class] allocWithZone:zone] init];
    style.barColor = self.barColor;
    style.textColor = self.textColor;
    style.font = self.font;
    style.animationType = self.animationType;
    return style;
}

@end

