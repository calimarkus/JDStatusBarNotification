//
//  main.m
//  JDStatusBarNotificationExample
//
//  Created by Markus on 29.10.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SBAppDelegate.h"

int main(int argc, char * argv[])
{
  @autoreleasepool {
#if IS_APPDELEGATE_BASED_EXAMPLE
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([SBAppDelegate class]));
#else
    return UIApplicationMain(argc, argv, nil, nil);
#endif
  }
}
