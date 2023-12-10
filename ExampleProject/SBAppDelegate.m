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
  _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  _window.rootViewController = [[SBExampleViewController alloc] initWithTitle:@"ExampleApp (AppDelegate)"];
  [_window makeKeyAndVisible];

  return YES;
}

@end
