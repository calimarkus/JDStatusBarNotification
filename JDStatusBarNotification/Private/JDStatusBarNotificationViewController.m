//
//

#import "JDStatusBarNotificationViewController.h"

#import "UIApplication+MainWindow.h"

// A custom view controller, so the statusBarStyle & rotation behaviour is correct
@implementation JDStatusBarNotificationViewController

// rotation

- (UIViewController *)mainController
{
  UIWindow *mainAppWindow = [[UIApplication sharedApplication] mainApplicationWindowIgnoringWindow:self.view.window];
  UIViewController *topController = mainAppWindow.rootViewController;

  while(topController.presentedViewController) {
    topController = topController.presentedViewController;
  }

  if ([topController respondsToSelector:@selector(topViewController)]) {
    topController = [((UINavigationController *)topController) topViewController];
  }

  return topController;
}

- (BOOL)shouldAutorotate {
  return [[self mainController] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return [[self mainController] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
  return [[self mainController] preferredInterfaceOrientationForPresentation];
}

// statusbar

static BOOL JDUIViewControllerBasedStatusBarAppearanceEnabled() {
  static BOOL enabled = YES;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    NSNumber *value = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIViewControllerBasedStatusBarAppearance"];
    if (value != nil) {
      enabled = [value boolValue];
    }
  });

  return enabled;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  if(JDUIViewControllerBasedStatusBarAppearanceEnabled()) {
    return [[self mainController] preferredStatusBarStyle];
  }

  return [[UIApplication sharedApplication] statusBarStyle];
}

- (BOOL)prefersStatusBarHidden {
    if(JDUIViewControllerBasedStatusBarAppearanceEnabled()) {
        return [[self mainController] prefersStatusBarHidden];
    }
    return [super prefersStatusBarHidden];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
  if(JDUIViewControllerBasedStatusBarAppearanceEnabled()) {
    return [[self mainController] preferredStatusBarUpdateAnimation];
  }
  return [super preferredStatusBarUpdateAnimation];
}

@end
