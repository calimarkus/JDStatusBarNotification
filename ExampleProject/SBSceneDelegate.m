//
//  SBSceneDelegate.m
//  JDStatusBarNotificationExample
//
//  Created by Markus on 29.10.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "SBExampleViewController.h"

#import "SBSceneDelegate.h"

@implementation SBSceneDelegate {
  UIWindow *_window;
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
  if ([scene isKindOfClass:[UIWindowScene class]]) {
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    _window = [[UIWindow alloc] initWithWindowScene:windowScene];
    _window.rootViewController = [[SBExampleViewController alloc] initWithTitle:@"ExampleApp (SceneDelegate)"];
    [_window makeKeyAndVisible];
  }
}

@end
