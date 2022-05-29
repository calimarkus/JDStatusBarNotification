//
//  SBAppDelegate.m
//  JDStatusBarNotificationExample
//
//  Created by Markus on 29.10.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "SBExampleViewController.h"

#import "SBAppDelegate.h"

@implementation SBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  BOOL isWindowSceneBased = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"ExampleIsWindowSceneBased"] boolValue];
  if (!isWindowSceneBased) {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:
                                      [[SBExampleViewController alloc] initWithStyle:UITableViewStyleInsetGrouped]];
    [self.window makeKeyAndVisible];
  }

  return YES;
}

@end
