//
//  SBAppDelegate.h
//  JDStatusBarNotificationExample
//
//  Created by Markus on 29.10.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import <UIKit/UIKit.h>

#if IS_SCENE_BASED_EXAMPLE

@interface SBSceneDelegate : UIResponder <UIWindowSceneDelegate>
@end

#else

@interface SBAppDelegate : UIResponder <UIApplicationDelegate>
@end

#endif
