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

#pragma mark - Presentation logic

- (JDStatusBarView *)showWithStatus:(NSString *)status
                              style:(JDStatusBarStyle *)style {
  if(_overlayWindow == nil) {
    _overlayWindow = [[JDStatusBarWindow alloc] initWithStyle:style windowScene:_windowScene];
    _overlayWindow.delegate = self;
  }

  JDStatusBarView *view = [_overlayWindow.statusBarViewController showWithStatus:status style:style];

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

#pragma mark - Style Management API

- (void)updateDefaultStyle:(JDStatusBarPrepareStyleBlock)prepareBlock {
  [_styleCache updateDefaultStyle:prepareBlock];
}

- (NSString*)addStyleNamed:(NSString*)identifier
                   prepare:(JDStatusBarPrepareStyleBlock)prepareBlock {
  return [_styleCache addStyleNamed:identifier prepare:prepareBlock];
}

#pragma mark - Presentation API

- (JDStatusBarView *)showWithStatus:(NSString *)status {
  return [self showWithStatus:status dismissAfterDelay:0.0 styleName:nil];
}

- (JDStatusBarView *)showWithStatus:(NSString *)status
                          styleName:(NSString * _Nullable)styleName {
  return [self showWithStatus:status dismissAfterDelay:0.0 styleName:styleName];
}

- (JDStatusBarView *)showWithStatus:(NSString *)status
                  dismissAfterDelay:(NSTimeInterval)timeInterval {
  return [self showWithStatus:status dismissAfterDelay:timeInterval styleName:nil];
}

- (JDStatusBarView *)showWithStatus:(NSString *)status
                  dismissAfterDelay:(NSTimeInterval)timeInterval
                          styleName:(NSString * _Nullable)styleName {
  JDStatusBarStyle *style = [_styleCache styleForName:styleName];
  JDStatusBarView *view = [self showWithStatus:status style:style];
  if (timeInterval > 0.0) {
    [self dismissAfterDelay:timeInterval];
  }
  return view;
}

#pragma mark - Dismissal API

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

#pragma mark - Other public API

- (void)updateStatus:(NSString *)status {
  [_overlayWindow.statusBarViewController.statusBarView setStatus:status];
}

- (void)showProgressBarWithPercentage:(CGFloat)percentage {
  [_overlayWindow.statusBarViewController.statusBarView setProgressBarPercentage:percentage];
}

- (void)showProgressBarWithPercentage:(CGFloat)percentage
                    animationDuration:(CGFloat)animationDuration
                           completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  __weak __typeof(self) weakSelf = self;
  [_overlayWindow.statusBarViewController.statusBarView setProgressBarPercentage:percentage
                                                               animationDuration:animationDuration
                                                                      completion:^{
    if (completion) {
      completion(weakSelf);
    }
  }];
}

- (void)showActivityIndicator:(BOOL)show {
  [_overlayWindow.statusBarViewController.statusBarView setDisplaysActivityIndicator:show];
}

- (BOOL)isVisible {
  return (_overlayWindow != nil);
}

@end
