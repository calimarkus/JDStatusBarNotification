//
//

#import "JDSystemStatusBarHelpers.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CGRect JDStatusBarFrameForWindowScene(UIWindowScene *_Nullable windowScene) {
  if (windowScene != nil) {
      if (([[windowScene statusBarManager] statusBarFrame].size.height > 0.0) || ([windowScene.windows firstObject] == nil)) {
          return [[windowScene statusBarManager] statusBarFrame];
      } else {
          UIWindow *window = [windowScene.windows firstObject];
          CGFloat top = window.safeAreaInsets.top;
          CGFloat width = [UIScreen mainScreen].bounds.size.width;
          return CGRectMake(0, 0, width, top);
      }
  } else if (([[UIApplication sharedApplication] statusBarFrame].size.height > 0.0) || ([[UIApplication sharedApplication] delegate].window == nil)) {
    return [[UIApplication sharedApplication] statusBarFrame];
  } else {
      CGFloat top = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.top;
      CGFloat width = [UIScreen mainScreen].bounds.size.width;
      return CGRectMake(0, 0, width, top);
  }
}

UIInterfaceOrientation JDStatusBarOrientationForWindowScene(UIWindowScene *_Nullable windowScene) {
  if (windowScene != nil) {
    return [windowScene interfaceOrientation];
  } else {
    return [[UIApplication sharedApplication] statusBarOrientation];
  }
}

#pragma clang diagnostic pop
