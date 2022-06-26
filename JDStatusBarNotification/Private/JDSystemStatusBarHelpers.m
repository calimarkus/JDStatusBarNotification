//
//

#import "JDSystemStatusBarHelpers.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

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

#pragma clang diagnostic pop
