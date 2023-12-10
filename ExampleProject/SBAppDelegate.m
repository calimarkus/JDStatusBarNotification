//
//  SBAppDelegate.m
//  JDStatusBarNotificationExample
//
//  Created by Markus on 29.10.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "SBExampleViewController.h"

#import "SBAppDelegate.h"

#if IS_SCENE_BASED_EXAMPLE

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

#else

@implementation SBAppDelegate {
  UIWindow *_window;

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  _window.rootViewController = [[SBExampleViewController alloc] initWithTitle:@"ExampleApp (AppDelegate)"];
  [_window makeKeyAndVisible];

  return YES;
}

@end

#endif
