//
//  JDStatusBarNotification.m
//
//  Based on KGStatusBar by Kevin Gibbon
//
//  Created by Markus Emrich on 10/28/13.
//  Copyright 2013 Markus Emrich. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "JDStatusBarNotification.h"

NSString *const JDStatusBarStyleError   = @"JDStatusBarStyleError";
NSString *const JDStatusBarStyleWarning = @"JDStatusBarStyleWarning";
NSString *const JDStatusBarStyleSuccess = @"JDStatusBarStyleSuccess";
NSString *const JDStatusBarStyleMatrix  = @"JDStatusBarStyleMatrix";
NSString *const JDStatusBarStyleDefault = @"JDStatusBarStyleDefault";
NSString *const JDStatusBarStyleDark    = @"JDStatusBarStyleDark";

@interface JDStatusBarNotification ()
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityView;
@property (nonatomic, strong, readonly) UIWindow *overlayWindow;
@property (nonatomic, strong, readonly) UIView *progressView;
@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) UIView *topBar;

@property (nonatomic, strong) NSTimer *dismissTimer;
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, weak) JDStatusBarStyle *activeStyle;
@property (nonatomic, strong) JDStatusBarStyle *defaultStyle;
@property (nonatomic, strong) NSMutableDictionary *userStyles;
@end

@implementation JDStatusBarNotification

@synthesize overlayWindow = _overlayWindow;
@synthesize progressView = _progressView;
@synthesize activityView = _activityView;
@synthesize textLabel = _textLabel;
@synthesize topBar = _topBar;

#pragma mark Class methods

+ (JDStatusBarNotification*)sharedInstance {
    static dispatch_once_t once;
    static JDStatusBarNotification *sharedInstance;
    dispatch_once(&once, ^ {
        sharedInstance = [[JDStatusBarNotification alloc] init];
    });
    return sharedInstance;
}

+ (UIView*)showWithStatus:(NSString *)status;
{
    return [[self sharedInstance] showWithStatus:status
                                       styleName:nil];
}

+ (UIView*)showWithStatus:(NSString *)status
                styleName:(NSString*)styleName;
{
    return [[self sharedInstance] showWithStatus:status
                                       styleName:styleName];
}

+ (UIView*)showWithStatus:(NSString *)status
             dismissAfter:(NSTimeInterval)timeInterval;
{
    UIView *view = [[self sharedInstance] showWithStatus:status
                                               styleName:nil];
    [self dismissAfter:timeInterval];
    return view;
}

+ (UIView*)showWithStatus:(NSString *)status
             dismissAfter:(NSTimeInterval)timeInterval
                styleName:(NSString*)styleName;
{
    UIView *view = [[self sharedInstance] showWithStatus:status
                                               styleName:styleName];
    [self dismissAfter:timeInterval];
    return view;
}

+ (void)dismiss;
{
    [self dismissAnimated:YES];
}

+ (void)dismissAnimated:(BOOL)animated;
{
    [[JDStatusBarNotification sharedInstance] dismissAnimated:animated];
}

+ (void)dismissAfter:(NSTimeInterval)delay;
{
    [[JDStatusBarNotification sharedInstance] setDismissTimerWithInterval:delay];
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
    return [[JDStatusBarNotification sharedInstance] addStyleNamed:identifier
                                                           prepare:prepareBlock];
}

+ (void)showProgress:(CGFloat)progress;
{
    [[JDStatusBarNotification sharedInstance] setProgress:progress];
}

+ (void)showActivityIndicator:(BOOL)show indicatorStyle:(UIActivityIndicatorViewStyle)style;
{
    [[JDStatusBarNotification sharedInstance] showActivityIndicator:show indicatorStyle:style];
}

+ (BOOL)isVisible;
{
    return [[JDStatusBarNotification sharedInstance] isVisible];
}

#pragma mark Implementation

- (id)init
{
    if ((self = [super init]))
    {
        // set defaults
        [self setupDefaultStyles];
        
        // register for orientation changes
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarFrame:)
                                                     name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Custom styles

- (void)setupDefaultStyles;
{
    // setup default style
    JDStatusBarStyle *defaultStyle = [[JDStatusBarStyle alloc] init];
    defaultStyle.barColor = [UIColor whiteColor];
    defaultStyle.progressBarColor = [UIColor greenColor];
    defaultStyle.progressBarHeight = 1.0;
    defaultStyle.progressBarPosition = JDStatusBarProgressBarPositionBottom;
    defaultStyle.textColor = [UIColor grayColor];
    defaultStyle.font = [UIFont systemFontOfSize:12.0];
    defaultStyle.animationType = JDStatusBarAnimationTypeMove;
    self.defaultStyle = defaultStyle;
    
    // init array
    self.userStyles = [NSMutableDictionary dictionary];
    
    // setup additional defaultStyles
    [self addStyleNamed:JDStatusBarStyleError
                prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
                    style.barColor = [UIColor colorWithRed:0.588 green:0.118 blue:0.000 alpha:1.000];
                    style.textColor = [UIColor whiteColor];
                    style.progressBarColor = [UIColor redColor];
                    style.progressBarHeight = 2.0;
                    return style;
                }];
    
    [self addStyleNamed:JDStatusBarStyleWarning
                prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
                    style.barColor = [UIColor colorWithRed:0.900 green:0.734 blue:0.034 alpha:1.000];
                    style.textColor = [UIColor darkGrayColor];
                    style.progressBarColor = style.textColor;
                    return style;
                }];
    
    [self addStyleNamed:JDStatusBarStyleSuccess
                prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
                    style.barColor = [UIColor colorWithRed:0.588 green:0.797 blue:0.000 alpha:1.000];
                    style.textColor = [UIColor whiteColor];
                    style.progressBarColor = [UIColor colorWithRed:0.106 green:0.594 blue:0.319 alpha:1.000];
                    style.progressBarHeight = 1.0+1.0/[[UIScreen mainScreen] scale];
                    return style;
                }];
    
    [self addStyleNamed:JDStatusBarStyleDark
                prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
                    style.barColor = [UIColor colorWithRed:0.050 green:0.078 blue:0.120 alpha:1.000];
                    style.textColor = [UIColor colorWithWhite:0.95 alpha:1.0];
                    style.progressBarHeight = 1.0+1.0/[[UIScreen mainScreen] scale];
                    return style;
                }];
    
    [self addStyleNamed:JDStatusBarStyleMatrix
                prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
                    style.barColor = [UIColor blackColor];
                    style.textColor = [UIColor greenColor];
                    style.font = [UIFont fontWithName:@"Courier-Bold" size:14.0];
                    style.progressBarColor = [UIColor greenColor];
                    style.progressBarHeight = 2.0;
                    return style;
                }];
}

- (NSString*)addStyleNamed:(NSString*)identifier
                   prepare:(JDPrepareStyleBlock)prepareBlock;
{
    NSAssert(identifier != nil, @"No identifier provided");
    NSAssert(prepareBlock != nil, @"No prepareBlock provided");
    
    JDStatusBarStyle *style = [self.defaultStyle copy];
    [self.userStyles setObject:prepareBlock(style) forKey:identifier];
    return identifier;
}

#pragma mark Presentation

- (UIView*)showWithStatus:(NSString *)status
                styleName:(NSString*)styleName;
{
    JDStatusBarStyle *style = nil;
    if (styleName != nil) {
        style = self.userStyles[styleName];
    }
    
    if (style == nil) style = self.defaultStyle;
    return [self showWithStatus:status style:style];
}

- (UIView*)showWithStatus:(NSString *)status
                    style:(JDStatusBarStyle*)style;
{
    // prepare for new style
    if (style != self.activeStyle) {
        self.activeStyle = style;
        if (self.activeStyle.animationType == JDStatusBarAnimationTypeFade) {
            self.topBar.alpha = 0.0;
            self.topBar.transform = CGAffineTransformIdentity;
        } else {
            self.topBar.alpha = 1.0;
            self.topBar.transform = CGAffineTransformMakeTranslation(0, -self.topBar.frame.size.height);
        }
    }
    
    // cancel previous dismissing & remove animations
    [[NSRunLoop currentRunLoop] cancelPerformSelector:@selector(dismiss) target:self argument:nil];
    [self.topBar.layer removeAllAnimations];
    
    // create & show window
    [self.overlayWindow setHidden:NO];
    
    // update style
    self.topBar.backgroundColor = style.barColor;
    self.progressView.backgroundColor = style.progressBarColor;
    self.textLabel.textColor = style.textColor;
    self.textLabel.font = style.font;
    self.textLabel.text = status;
    self.textLabel.frame = CGRectMake(0, 1+style.textVerticalPositionAdjustment,
                                      self.topBar.bounds.size.width, self.topBar.bounds.size.height-1);
    
    if (style.textShadow) {
        self.textLabel.shadowColor = style.textShadow.shadowColor;
        self.textLabel.shadowOffset = style.textShadow.shadowOffset;
    } else {
        self.textLabel.shadowColor = nil;
        self.textLabel.shadowOffset = CGSizeZero;
    }
    
    // reset progress & activity
    self.progress = 0.0;
    [self showActivityIndicator:NO indicatorStyle:0];
    
    // animate in
    BOOL animationsEnabled = (style.animationType != JDStatusBarAnimationTypeNone);
    if (animationsEnabled && style.animationType == JDStatusBarAnimationTypeBounce) {
        [self animateInWithBounceAnimation];
    } else {
        [UIView animateWithDuration:(animationsEnabled ? 0.4 : 0.0) animations:^{
            self.topBar.alpha = 1.0;
            self.topBar.transform = CGAffineTransformIdentity;
        }];
    }
    
    return self.topBar;
}

#pragma mark Dismissal

- (void)setDismissTimerWithInterval:(NSTimeInterval)interval;
{
    [self.dismissTimer invalidate];
    self.dismissTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]
                                                 interval:0 target:self selector:@selector(dismiss:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.dismissTimer forMode:NSRunLoopCommonModes];
}

- (void)dismiss:(NSTimer*)timer;
{
    [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated;
{
    [self.dismissTimer invalidate];
    self.dismissTimer = nil;
    
    // check animation type
    BOOL animationsEnabled = (self.activeStyle.animationType != JDStatusBarAnimationTypeNone);
    animated &= animationsEnabled;
    
    // animate out
    [UIView animateWithDuration:animated ? 0.4 : 0.0 animations:^{
        if (self.activeStyle.animationType == JDStatusBarAnimationTypeFade) {
            self.topBar.alpha = 0.0;
        } else {
            self.topBar.transform = CGAffineTransformMakeTranslation(0, -self.topBar.frame.size.height);
        }
    } completion:^(BOOL finished) {
        [self.overlayWindow removeFromSuperview];
        [self.overlayWindow setHidden:YES];
        _overlayWindow = nil;
        _activityView = nil;
        _progressView = nil;
        _textLabel = nil;
        _topBar = nil;
    }];
}

#pragma mark Bounce Animation

- (void)animateInWithBounceAnimation;
{
    //don't animate in, if topBar is already fully visible
    if (self.topBar.frame.origin.y >= 0) {
        return;
    }
    
    // easing function (based on github.com/robb/RBBAnimation)
    CGFloat(^RBBEasingFunctionEaseOutBounce)(CGFloat) = ^CGFloat(CGFloat t) {
        if (t < 4.0 / 11.0) return pow(11.0 / 4.0, 2) * pow(t, 2);
        if (t < 8.0 / 11.0) return 3.0 / 4.0 + pow(11.0 / 4.0, 2) * pow(t - 6.0 / 11.0, 2);
        if (t < 10.0 / 11.0) return 15.0 /16.0 + pow(11.0 / 4.0, 2) * pow(t - 9.0 / 11.0, 2);
        return 63.0 / 64.0 + pow(11.0 / 4.0, 2) * pow(t - 21.0 / 22.0, 2);
    };
    
    // create values
    int fromCenterY=-20, toCenterY=0, animationSteps=100;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:animationSteps];
    for (int t = 1; t<=animationSteps; t++) {
        float easedTime = RBBEasingFunctionEaseOutBounce((t*1.0)/animationSteps);
        float easedValue = fromCenterY + easedTime * (toCenterY-fromCenterY);
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, easedValue, 0)]];
    }
    
    // build animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.66;
    animation.values = values;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    [self.topBar.layer setValue:@(toCenterY) forKeyPath:animation.keyPath];
    [self.topBar.layer addAnimation:animation forKey:@"JDBounceAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
{
    self.topBar.transform = CGAffineTransformIdentity;
    [self.topBar.layer removeAllAnimations];
}

#pragma mark Progress & Activity

- (void)setProgress:(CGFloat)progress;
{
    if (_topBar == nil) return;
    
    // trim progress
    _progress = MIN(1.0, MAX(0.0,progress));
    
    if (_progress == 0.0) {
        self.progressView.frame = CGRectZero;
        return;
    }
    
    // update superview
    if (self.activeStyle.progressBarPosition == JDStatusBarProgressBarPositionBelow ||
        self.activeStyle.progressBarPosition == JDStatusBarProgressBarPositionNavBar) {
        [self.topBar.superview addSubview:self.progressView];
    } else {
        [self.topBar insertSubview:self.progressView belowSubview:self.textLabel];
    }
    
    // calculate progressView frame
    CGRect frame = self.topBar.bounds;
    CGFloat height = MIN(frame.size.height,MAX(0.5, self.activeStyle.progressBarHeight));
    if (height == 20.0 && frame.size.height > height) height = frame.size.height;
    frame.size.height = height;
    frame.size.width = round(frame.size.width * progress);
    
    // apply y-position from active style
    CGFloat barHeight = self.topBar.bounds.size.height;
    if (self.activeStyle.progressBarPosition == JDStatusBarProgressBarPositionBottom) {
        frame.origin.y = barHeight - height;
    } else if(self.activeStyle.progressBarPosition == JDStatusBarProgressBarPositionCenter) {
        frame.origin.y = round((barHeight - height)/2.0);
    } else if(self.activeStyle.progressBarPosition == JDStatusBarProgressBarPositionTop) {
        frame.origin.y = 0.0;
    } else if(self.activeStyle.progressBarPosition == JDStatusBarProgressBarPositionBelow) {
        frame.origin.y = barHeight;
    } else if(self.activeStyle.progressBarPosition == JDStatusBarProgressBarPositionNavBar) {
        CGFloat navBarHeight = 44.0;
        if (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) &&
            UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
            navBarHeight = 32.0;
        }
        frame.origin.y = barHeight + navBarHeight;
    }
    
    // update progressView frame
    BOOL animated = !CGRectEqualToRect(self.progressView.frame, CGRectZero);
    [UIView animateWithDuration:animated ? 0.05 : 0.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.progressView.frame = frame;
    } completion:nil];
}

- (void)showActivityIndicator:(BOOL)show
               indicatorStyle:(UIActivityIndicatorViewStyle)style;
{
    if (_topBar == nil) return;
    
    if (show) {
        CGSize textSize = CGSizeZero;
        SEL selector = @selector(sizeWithAttributes:);
        if ([self.textLabel.text respondsToSelector:selector]) {
            // use invocation, for iOS 6.0 SDK support
            NSDictionary *attributes = @{NSFontAttributeName:self.textLabel.font};
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                        [[NSString class] instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:self.textLabel.text];
            [invocation setArgument:&attributes atIndex:2];
            [invocation invoke];
            [invocation getReturnValue:&textSize];
        } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000 // only when deployment target is < ios7
            textSize = [self.textLabel.text sizeWithFont:self.textLabel.font];
#endif
        }
        
        [self.activityView startAnimating];
        self.activityView.activityIndicatorViewStyle = style;
        [self.topBar addSubview:self.activityView];
        [self.activityView sizeToFit];
        CGRect frame = self.activityView.frame;
        frame.origin.x = round(self.topBar.bounds.size.width/2.0 - textSize.width/2.0) - frame.size.width - 8.0;
        frame.origin.y = ceil((self.textLabel.bounds.size.height - frame.size.height)/2.0) + self.textLabel.frame.origin.y;
        frame.origin.y -= self.activeStyle.textVerticalPositionAdjustment;
        self.activityView.frame = frame;
    } else {
        [self.activityView stopAnimating];
        [self.activityView removeFromSuperview];
    }
}

#pragma mark State

- (BOOL)isVisible;
{
    return (_topBar != nil);
}

#pragma mark Lazy views

- (UIWindow *)overlayWindow;
{
    if(_overlayWindow == nil) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.userInteractionEnabled = NO;
        _overlayWindow.windowLevel = UIWindowLevelStatusBar;
        _overlayWindow.rootViewController = [[UIViewController alloc] init];
        _overlayWindow.rootViewController.view.backgroundColor = [UIColor clearColor];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000 // only when deployment target is < ios7
        _overlayWindow.rootViewController.wantsFullScreenLayout = YES;
#endif
        [self updateWindowTransform];
        [self updateTopBarFrameWithStatusBarFrame:[[UIApplication sharedApplication] statusBarFrame]];
    }
    return _overlayWindow;
}

- (UIView *)topBar;
{
    if(_topBar == nil) {
        _topBar = [[UIView alloc] initWithFrame:CGRectZero];
        _topBar.alpha = 0.0;
        [self.topBar addSubview:self.textLabel];
        [self.overlayWindow.rootViewController.view addSubview:_topBar];
        
        JDStatusBarStyle *style = self.activeStyle ?: self.defaultStyle;
        if (style.animationType != JDStatusBarAnimationTypeFade) {
            self.topBar.alpha = 1.0;
            self.topBar.transform = CGAffineTransformMakeTranslation(0, -self.topBar.frame.size.height);
        }
    }
    return _topBar;
}

- (UILabel *)textLabel;
{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _textLabel.textAlignment = NSTextAlignmentCenter;
		_textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.clipsToBounds = YES;
    }
    return _textLabel;
}

- (UIView *)progressView;
{
    if (_progressView == nil) {
        _progressView = [[UIView alloc] initWithFrame:CGRectZero];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _progressView;
}

- (UIActivityIndicatorView *)activityView;
{
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _activityView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        _activityView.hidesWhenStopped = NO;
    }
    return _activityView;
}

#pragma mark Rotation

- (void)updateWindowTransform;
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (window == nil && [[[UIApplication sharedApplication] windows] count] > 0) window = [[UIApplication sharedApplication] windows][0];
    
    _overlayWindow.transform = window.transform;
    _overlayWindow.frame = window.frame;
}

- (void)updateTopBarFrameWithStatusBarFrame:(CGRect)rect;
{
    CGFloat width = MAX(rect.size.width, rect.size.height);
    CGFloat height = MIN(rect.size.width, rect.size.height);

    // on ios7 fix position, if statusBar has double height
    CGFloat yPos = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && height > 20.0) {
        yPos = -height/2.0;
    }
    
    _topBar.frame = CGRectMake(0, yPos, width, height);
}

- (void)willChangeStatusBarFrame:(NSNotification*)notification;
{
    NSValue *barFrameValue = notification.userInfo[UIApplicationStatusBarFrameUserInfoKey];
    [UIView animateWithDuration:0.5 animations:^{
        [self updateWindowTransform];
        [self updateTopBarFrameWithStatusBarFrame:[barFrameValue CGRectValue]];
    }];
}

@end

@implementation JDStatusBarStyle

- (instancetype)copyWithZone:(NSZone *)zone;
{
    JDStatusBarStyle *style = [[[self class] allocWithZone:zone] init];
    style.barColor = self.barColor;
    style.textColor = self.textColor;
    style.textShadow = self.textShadow;
    style.font = self.font;
    style.textVerticalPositionAdjustment = self.textVerticalPositionAdjustment;
    style.animationType = self.animationType;
    style.progressBarColor = self.progressBarColor;
    style.progressBarHeight = self.progressBarHeight;
    style.progressBarPosition = self.progressBarPosition;
    return style;
}

@end

