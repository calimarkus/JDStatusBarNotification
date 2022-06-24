//
//

#import "JDSystemStatusBarHelpers.h"

CGRect JDStatusBarFrameForWindowScene(UIWindowScene *_Nullable windowScene) {
  if (windowScene != nil) {
    return [[windowScene statusBarManager] statusBarFrame];
  } else {
    return [[UIApplication sharedApplication] statusBarFrame];
  }
}

UIInterfaceOrientation JDStatusBarOrientationForWindowScene(UIWindowScene *_Nullable windowScene) {
  if (windowScene != nil) {
    return [windowScene interfaceOrientation];
  } else {
    return [[UIApplication sharedApplication] statusBarOrientation];
  }
}
