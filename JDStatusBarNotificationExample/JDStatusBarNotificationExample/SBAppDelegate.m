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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 6.0) {
        NSDictionary *navbarTitle = @{UITextAttributeFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17.0],
                                      UITextAttributeTextColor:[UIColor colorWithWhite:0.15 alpha:1.0],
                                      UITextAttributeTextShadowColor:[UIColor clearColor],
                                      UITextAttributeTextShadowOffset:[NSValue valueWithCGSize:CGSizeMake(0, 0)]};
        
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.794 green:0.792 blue:0.82 alpha:1.0]];
        [[UINavigationBar appearance] setTitleTextAttributes:navbarTitle];
        [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:2.0 forBarMetrics:UIBarMetricsDefault];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:
                                      [[SBExampleViewController alloc] init]];
    
    return YES;
}

@end
