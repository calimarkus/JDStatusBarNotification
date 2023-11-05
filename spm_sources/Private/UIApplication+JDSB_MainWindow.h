//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (JDSB_MainWindow)

- (UIWindow * _Nullable)jdsb_mainApplicationWindowIgnoringWindow:(UIWindow * _Nullable)ignoringWindow;

- (UIViewController * _Nullable)jdsb_mainControllerIgnoringViewController:(UIViewController * _Nullable)viewController;

@end

NS_ASSUME_NONNULL_END
