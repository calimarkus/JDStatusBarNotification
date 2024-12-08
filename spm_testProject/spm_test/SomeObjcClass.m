//
//

#import "SomeObjcClass.h"

@import JDStatusBarNotification;

@implementation SomeObjcClass

- (void)someMethodToVerifyObjcImportAndPresentCallDoesCompile {
  [[JDStatusBarNotificationPresenter sharedPresenter] presentWithText:@"text"];
}

@end
