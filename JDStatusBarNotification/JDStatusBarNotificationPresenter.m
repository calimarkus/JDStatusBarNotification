//
//  JDStatusBarNotificationPresenter.m
//
//  Based on KGStatusBar by Kevin Gibbon
//
//  Created by Markus Emrich on 10/28/13.
//  Copyright 2013 Markus Emrich. All rights reserved.
//

#import "JDStatusBarNotificationPresenter.h"

#import "JDStatusBarStyleCache.h"
#import "JDStatusBarNotificationViewController.h"
#import "JDStatusBarView.h"
#import "JDStatusBarWindow.h"

@interface JDStatusBarNotificationPresenter () <JDStatusBarWindowDelegate>
@end

@implementation JDStatusBarNotificationPresenter {
  UIWindowScene *_windowScene;
  JDStatusBarWindow *_overlayWindow;
  JDStatusBarStyleCache *_styleCache;
}

#pragma mark - Singleton

+ (instancetype)sharedPresenter {
  static dispatch_once_t once;
  static JDStatusBarNotificationPresenter *sharedInstance;
  dispatch_once(&once, ^ {
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

#pragma mark - Implementation

- (instancetype)init {
  self = [super init];
  if (self) {
    _styleCache = [[JDStatusBarStyleCache alloc] init];
  }
  return self;
}

#pragma mark - Window Scene

- (void)setWindowScene:(UIWindowScene *)windowScene {
  _windowScene = windowScene;
}

#pragma mark - Core Presentation logic

- (JDStatusBarView *)presentWithText:(NSString *)text
                              style:(JDStatusBarStyle *)style
                          completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  if(_overlayWindow == nil) {
    _overlayWindow = [[JDStatusBarWindow alloc] initWithStyle:style windowScene:_windowScene];
    _overlayWindow.delegate = self;
  }

  JDStatusBarView *view = [_overlayWindow.statusBarViewController presentWithText:text style:style completion:^{
    if (completion) {
      completion(self);
    }
  }];

  [_overlayWindow setHidden:NO];
  [_overlayWindow.statusBarViewController setNeedsStatusBarAppearanceUpdate];

  return view;
}

#pragma mark - JDStatusBarWindowDelegate

- (void)didDismissStatusBar {
  [_overlayWindow removeFromSuperview];
  [_overlayWindow setHidden:YES];
  _overlayWindow.rootViewController = nil;
  _overlayWindow = nil;
}

#pragma mark - Simple Presentation

- (JDStatusBarView *)presentWithText:(NSString *)text {
  return [self presentWithText:text dismissAfterDelay:0.0 customStyle:nil completion:nil];
}
- (JDStatusBarView *)presentWithText:(NSString *)text
                          completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  return [self presentWithText:text dismissAfterDelay:0.0 customStyle:nil completion:completion];
}

- (JDStatusBarView *)presentWithText:(NSString *)text
                   dismissAfterDelay:(NSTimeInterval)delay {
  return [self presentWithText:text dismissAfterDelay:delay customStyle:nil completion:nil];
}

#pragma mark - Custom Style Presentation

- (JDStatusBarView *)presentWithText:(NSString *)text
                         customStyle:(NSString * _Nullable)styleName {
  return [self presentWithText:text dismissAfterDelay:0.0 customStyle:styleName completion:nil];
}

- (JDStatusBarView *)presentWithText:(NSString *)text
                         customStyle:(NSString * _Nullable)styleName
                          completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  return [self presentWithText:text dismissAfterDelay:0.0 customStyle:styleName completion:completion];
}

- (JDStatusBarView *)presentWithText:(NSString *)text
                   dismissAfterDelay:(NSTimeInterval)delay
                         customStyle:(NSString * _Nullable)styleName {
  return [self presentWithText:text dismissAfterDelay:delay customStyle:styleName completion:nil];
}

- (JDStatusBarView *)presentWithText:(NSString *)text
                   dismissAfterDelay:(NSTimeInterval)delay
                         customStyle:(NSString * _Nullable)styleName
                          completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  JDStatusBarStyle *style = [_styleCache styleForName:styleName];
  JDStatusBarView *view = [self presentWithText:text style:style completion:completion];
  if (delay > 0.0) {
    [self dismissAfterDelay:delay];
  }
  return view;
}

#pragma mark - Included Style Presentation

- (JDStatusBarView *)presentWithText:(NSString *)text
                       includedStyle:(JDStatusBarIncludedStyle)includedStyle {
  return [self presentWithText:text dismissAfterDelay:0.0 includedStyle:includedStyle completion:nil];
}

- (JDStatusBarView *)presentWithText:(NSString *)text
                       includedStyle:(JDStatusBarIncludedStyle)includedStyle
                          completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  return [self presentWithText:text dismissAfterDelay:0.0 includedStyle:includedStyle completion:completion];
}

- (JDStatusBarView *)presentWithText:(NSString *)text
                   dismissAfterDelay:(NSTimeInterval)delay
                       includedStyle:(JDStatusBarIncludedStyle)includedStyle {
  return [self presentWithText:text dismissAfterDelay:delay includedStyle:includedStyle completion:nil];
}

- (JDStatusBarView *)presentWithText:(NSString *)text
                   dismissAfterDelay:(NSTimeInterval)delay
                       includedStyle:(JDStatusBarIncludedStyle)includedStyle
                          completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  JDStatusBarStyle *style = [_styleCache styleForIncludedStyle:includedStyle];
  JDStatusBarView *view = [self presentWithText:text style:style completion:completion];
  if (delay > 0.0) {
    [self dismissAfterDelay:delay];
  }
  return view;
}

#pragma mark - Dismissal

- (void)dismissAfterDelay:(NSTimeInterval)delay {
  [_overlayWindow.statusBarViewController dismissAfterDelay:delay completion:nil];
}

- (void)dismissAfterDelay:(NSTimeInterval)delay
               completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  __weak __typeof(self) weakSelf = self;
  [_overlayWindow.statusBarViewController dismissAfterDelay:delay completion:^{
    if (completion) {
      completion(weakSelf);
    }
  }];
}

- (void)dismissAnimated:(BOOL)animated {
  [_overlayWindow.statusBarViewController dismissWithDuration:animated ? 0.4 : 0.0 completion:nil];
}

#pragma mark - Style Management API

- (void)updateDefaultStyle:(NS_NOESCAPE JDStatusBarPrepareStyleBlock)prepareBlock {
  [_styleCache updateDefaultStyle:prepareBlock];
}

- (NSString *)addStyleNamed:(NSString *)styleName
                    prepare:(NS_NOESCAPE JDStatusBarPrepareStyleBlock)prepareBlock {
  return [_styleCache addStyleNamed:styleName prepare:prepareBlock];
}

- (NSString *)addStyleNamed:(NSString*)styleName
               basedOnStyle:(JDStatusBarIncludedStyle)basedOnStyle
                    prepare:(NS_NOESCAPE JDStatusBarPrepareStyleBlock)prepareBlock {
  return [_styleCache addStyleNamed:styleName basedOnStyle:basedOnStyle prepare:prepareBlock];
}

#pragma mark - Progress Bar

- (void)displayProgressBarWithPercentage:(CGFloat)percentage {
  [_overlayWindow.statusBarViewController.statusBarView setProgressBarPercentage:percentage];
}

- (void)animateProgressBarToPercentage:(CGFloat)percentage
                     animationDuration:(CGFloat)animationDuration
                            completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  __weak __typeof(self) weakSelf = self;
  [_overlayWindow.statusBarViewController.statusBarView animateProgressBarToPercentage:percentage
                                                                     animationDuration:animationDuration
                                                                            completion:^{
    if (completion) {
      completion(weakSelf);
    }
  }];
}
#pragma mark - Activity Indicator

- (void)displayActivityIndicator:(BOOL)show {
  [_overlayWindow.statusBarViewController.statusBarView setDisplaysActivityIndicator:show];
}

#pragma mark - Others

- (void)updateText:(NSString *)text {
  [_overlayWindow.statusBarViewController.statusBarView setText:text];
}

- (BOOL)isVisible {
  return (_overlayWindow != nil);
}

@end
