//
//

#import "UIApplication+JDSB_MainWindow.h"

@implementation UIApplication (JDSB_MainWindow)

// we don't want the keyWindow, since it could be our own window
- (UIWindow *)jdsb_mainApplicationWindowIgnoringWindow:(UIWindow *)ignoringWindow {
  NSArray *allWindows;
  if (ignoringWindow.windowScene != nil) {
    allWindows = ignoringWindow.windowScene.windows;
  } else {
    allWindows = [[UIApplication sharedApplication] windows];
  }
  for (UIWindow *window in allWindows) {
    if (!window.hidden && window != ignoringWindow) {
      return window;
    }
  }
  return nil;
}

- (UIViewController *)jdsb_mainControllerIgnoringViewController:(UIViewController *)viewController {
  UIWindow *mainAppWindow = [self jdsb_mainApplicationWindowIgnoringWindow:viewController.view.window];
  UIViewController *topController = mainAppWindow.rootViewController;

  while(topController.presentedViewController) {
    topController = topController.presentedViewController;
  }

  if ([topController respondsToSelector:@selector(topViewController)]) {
    topController = [((UINavigationController *)topController) topViewController];
  }

  // ensure we never end up with recursive calls
  if (topController == viewController) {
    return nil;
  }

  return topController;
}

@end
