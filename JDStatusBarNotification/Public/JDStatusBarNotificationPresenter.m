//
//  JDStatusBarNotificationPresenter.m
//
//  Based on KGStatusBar by Kevin Gibbon
//
//  Created by Markus Emrich on 10/28/13.
//  Copyright 2013 Markus Emrich. All rights reserved.
//

#import "JDStatusBarNotificationPresenter.h"

#import "JDSBNotificationView.h"
#import "JDSBNotificationViewController.h"
#import "JDSBNotificationStyleCache.h"
#import "JDSBNotificationWindow.h"

@interface JDStatusBarNotificationPresenter () <JDSBNotificationWindowDelegate>
@end

@implementation JDStatusBarNotificationPresenter {
  UIWindowScene *_windowScene;
  JDSBNotificationWindow *_overlayWindow;
  JDSBNotificationStyleCache *_styleCache;
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
    _styleCache = [[JDSBNotificationStyleCache alloc] init];
  }
  return self;
}

#pragma mark - Core Presentation logic

- (JDSBNotificationView *)presentWithTitle:(NSString *)title
                             subtitle:(NSString *)subtitle
                                style:(JDStatusBarNotificationStyle *)style
                           completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  if(_overlayWindow == nil) {
    _overlayWindow = [[JDSBNotificationWindow alloc] initWithStyle:style windowScene:_windowScene];
    _overlayWindow.delegate = self;
  }

  JDSBNotificationView *view = [_overlayWindow.statusBarViewController presentWithTitle:title subtitle:subtitle style:style completion:^{
    if (completion) {
      completion(self);
    }
  }];

  [_overlayWindow setHidden:NO];
  [_overlayWindow.statusBarViewController setNeedsStatusBarAppearanceUpdate];

  return view;
}

#pragma mark - JDSBNotificationWindowDelegate

- (void)didDismissStatusBar {
  [_overlayWindow removeFromSuperview];
  [_overlayWindow setHidden:YES];
  _overlayWindow.rootViewController = nil;
  _overlayWindow = nil;
}

#pragma mark - Simple Presentation

- (UIView *)presentWithText:(NSString *)text {
  return [self presentWithTitle:text subtitle:nil dismissAfterDelay:0.0 customStyle:nil completion:nil];
}
- (UIView *)presentWithText:(NSString *)text
                 completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  return [self presentWithTitle:text subtitle:nil dismissAfterDelay:0.0 customStyle:nil completion:completion];
}
- (UIView *)presentWithTitle:(NSString *)title
                    subtitle:(NSString * _Nullable)subtitle
                  completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  return [self presentWithTitle:title subtitle:subtitle dismissAfterDelay:0.0 customStyle:nil completion:completion];
}
- (UIView *)presentWithText:(NSString *)text
          dismissAfterDelay:(NSTimeInterval)delay {
  return [self presentWithTitle:text subtitle:nil dismissAfterDelay:delay customStyle:nil completion:nil];
}

#pragma mark - Custom Style Presentation

- (UIView *)presentWithText:(NSString *)text
                customStyle:(NSString * _Nullable)styleName {
  return [self presentWithTitle:text subtitle:nil dismissAfterDelay:0.0 customStyle:styleName completion:nil];
}

- (UIView *)presentWithText:(NSString *)text
                customStyle:(NSString * _Nullable)styleName
                 completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  return [self presentWithTitle:text subtitle:nil dismissAfterDelay:0.0 customStyle:styleName completion:completion];
}

- (UIView *)presentWithTitle:(NSString *)title
                    subtitle:(NSString * _Nullable)subtitle
                 customStyle:(NSString * _Nullable)styleName
                  completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  return [self presentWithTitle:title subtitle:subtitle dismissAfterDelay:0.0 customStyle:styleName completion:completion];
}

- (UIView *)presentWithText:(NSString *)text
          dismissAfterDelay:(NSTimeInterval)delay
                customStyle:(NSString * _Nullable)styleName {
  return [self presentWithTitle:text subtitle:nil dismissAfterDelay:delay customStyle:styleName completion:nil];
}

- (UIView *)presentWithTitle:(NSString *)title
                    subtitle:(NSString * _Nullable)subtitle
           dismissAfterDelay:(NSTimeInterval)delay
                 customStyle:(NSString * _Nullable)styleName
                  completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  JDStatusBarNotificationStyle *style = [_styleCache styleForName:styleName];
  UIView *view = [self presentWithTitle:title subtitle:subtitle style:style completion:completion];
  if (delay > 0.0) {
    [self dismissAfterDelay:delay];
  }
  return view;
}

#pragma mark - Included Style Presentation

- (UIView *)presentWithText:(NSString *)text
              includedStyle:(JDStatusBarNotificationIncludedStyle)includedStyle {
  return [self presentWithTitle:text subtitle:nil dismissAfterDelay:0.0 includedStyle:includedStyle completion:nil];
}

- (UIView *)presentWithText:(NSString *)text
              includedStyle:(JDStatusBarNotificationIncludedStyle)includedStyle
                 completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  return [self presentWithTitle:text subtitle:nil dismissAfterDelay:0.0 includedStyle:includedStyle completion:completion];
}

- (UIView *)presentWithTitle:(NSString *)title
                    subtitle:(NSString * _Nullable)subtitle
               includedStyle:(JDStatusBarNotificationIncludedStyle)includedStyle
                  completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  return [self presentWithTitle:title subtitle:subtitle dismissAfterDelay:0.0 includedStyle:includedStyle completion:completion];
}

- (UIView *)presentWithText:(NSString *)text
          dismissAfterDelay:(NSTimeInterval)delay
              includedStyle:(JDStatusBarNotificationIncludedStyle)includedStyle {
  return [self presentWithTitle:text subtitle:nil dismissAfterDelay:delay includedStyle:includedStyle completion:nil];
}

- (UIView *)presentWithTitle:(NSString *)title
                    subtitle:(NSString *)subtitle
           dismissAfterDelay:(NSTimeInterval)delay
               includedStyle:(JDStatusBarNotificationIncludedStyle)includedStyle
                  completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  JDStatusBarNotificationStyle *style = [_styleCache styleForIncludedStyle:includedStyle];
  UIView *view = [self presentWithTitle:title subtitle:subtitle style:style completion:completion];
  if (delay > 0.0) {
    [self dismissAfterDelay:delay];
  }
  return view;
}

#pragma mark - Custom View Presentation

- (UIView *)presentWithCustomView:(UIView *)customView
                        styleName:(NSString * _Nullable)styleName
                       completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  JDStatusBarNotificationStyle *style = [_styleCache styleForName:styleName];
  JDSBNotificationView *view = [self presentWithTitle:nil subtitle:nil style:style completion:completion];
  view.customSubview = customView;
  return view;
}

#pragma mark - Dismissal

- (void)dismiss {
  [self dismissAnimated:YES completion:nil];
}

- (void)dismissWithCompletion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  [self dismissAnimated:YES completion:completion];
}

- (void)dismissAnimated:(BOOL)animated {
  [self dismissAnimated:animated completion:nil];
}

- (void)dismissAnimated:(BOOL)animated completion:(JDStatusBarNotificationPresenterCompletionBlock)completion {
  __weak __typeof(self) weakSelf = self;
  [_overlayWindow.statusBarViewController dismissWithDuration:animated ? 0.4 : 0.0 completion:^{
    if (completion) {
      completion(weakSelf);
    }
  }];
}

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

#pragma mark - Style Management API

- (void)updateDefaultStyle:(NS_NOESCAPE JDStatusBarNotificationPresenterPrepareStyleBlock)prepareBlock {
  [_styleCache updateDefaultStyle:prepareBlock];
}

- (NSString *)addStyleNamed:(NSString *)styleName
                    prepare:(NS_NOESCAPE JDStatusBarNotificationPresenterPrepareStyleBlock)prepareBlock {
  return [_styleCache addStyleNamed:styleName prepare:prepareBlock];
}

- (NSString *)addStyleNamed:(NSString*)styleName
               basedOnStyle:(JDStatusBarNotificationIncludedStyle)basedOnStyle
                    prepare:(NS_NOESCAPE JDStatusBarNotificationPresenterPrepareStyleBlock)prepareBlock {
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
#pragma mark - Left View

- (void)displayActivityIndicator:(BOOL)show {
  [_overlayWindow.statusBarViewController.statusBarView setDisplaysActivityIndicator:show];
}

- (void)displayLeftView:(UIView * _Nullable)leftView {
  [_overlayWindow.statusBarViewController.statusBarView setLeftView:leftView];
}

#pragma mark - Others

- (void)updateText:(NSString *)text {
  [_overlayWindow.statusBarViewController.statusBarView setTitle:text];
}

- (void)updateSubtitle:(NSString *)subtitle {
  [_overlayWindow.statusBarViewController.statusBarView setSubtitle:subtitle];
}

- (BOOL)isVisible {
  return (_overlayWindow != nil);
}

#pragma mark - Window Scene

- (void)setWindowScene:(UIWindowScene *)windowScene {
  _windowScene = windowScene;
}

@end
