//
//  SBAppDelegate.m
//  JDStatusBarNotificationExample
//
//  Created by Markus on 29.10.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "SBExampleViewController.h"

#import "SBAppDelegate.h"

@implementation SBAppDelegate {
  UIWindow *_window;

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  BOOL isWindowSceneBased = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"ExampleIsWindowSceneBased"] boolValue];
  if (!isWindowSceneBased) {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.rootViewController = [SBExampleViewController new];
    [_window makeKeyAndVisible];
  }
  
  return YES;
}

@end

@implementation SBSceneDelegate {
  UIWindow *_window;
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
  if ([scene isKindOfClass:[UIWindowScene class]]) {
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    _window = [[UIWindow alloc] initWithWindowScene:windowScene];
    _window.rootViewController = [SBExampleViewController new];
    [_window makeKeyAndVisible];
  }
}

@end
