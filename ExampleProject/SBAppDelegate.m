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

#if !IS_SCENE_BASED_EXAMPLE
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  _window.rootViewController = [[SBExampleViewController alloc] initWithTitle:@"ExampleApp (AppDelegate)"];
  [_window makeKeyAndVisible];

  return YES;
}
#endif

@end

@implementation SBSceneDelegate {
  UIWindow *_window;
}

#if IS_SCENE_BASED_EXAMPLE
- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
  if ([scene isKindOfClass:[UIWindowScene class]]) {
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    _window = [[UIWindow alloc] initWithWindowScene:windowScene];
    _window.rootViewController = [[SBExampleViewController alloc] initWithTitle:@"ExampleApp (SceneDelegate)"];
    [_window makeKeyAndVisible];
  }
}
#endif

@end
