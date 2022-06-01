//
//

#import "JDStatusBarLayoutMarginHelper.h"

UIEdgeInsets JDStatusBarRootVCLayoutMarginForWindow(UIWindow *window)
{
  UIEdgeInsets layoutMargins = window.rootViewController.view.layoutMargins;
  if (layoutMargins.top > 8 && layoutMargins.bottom > 8) {
    return layoutMargins;
  } else {
    return UIEdgeInsetsZero;  // ignore default margins
  }
}
