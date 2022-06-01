//
//

#import "UIApplication+MainWindow.h"

@implementation UIApplication (MainWindow)

// we don't want the keyWindow, since it could be our own window
- (UIWindow *)mainApplicationWindowIgnoringWindow:(UIWindow *)ignoringWindow {
  for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
    if (!window.hidden && window != ignoringWindow) {
      return window;
    }
  }
  return nil;
}
@end
