//
//

#import "UIApplication+MainWindow.h"

@implementation UIApplication (MainWindow)

// we don't want the keyWindow, since it could be our own window
- (UIWindow *)mainApplicationWindowIgnoringWindow:(UIWindow *)ignoringWindow {
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
@end
