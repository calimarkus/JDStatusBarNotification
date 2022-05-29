//
//

#import "SBSceneDelegate.h"

#import "SBExampleViewController.h"
#import "JDStatusBarNotification.h"

@implementation SBSceneDelegate {
    UIWindow *_window;
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    if ([scene isKindOfClass:[UIWindowScene class]]) {
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        _window = [[UIWindow alloc] initWithWindowScene:windowScene];
        _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:
                                          [[SBExampleViewController alloc] initWithStyle:UITableViewStyleInsetGrouped]];
        [_window makeKeyAndVisible];

        [JDStatusBarNotification setWindowScene:windowScene];
    }
}

@end
