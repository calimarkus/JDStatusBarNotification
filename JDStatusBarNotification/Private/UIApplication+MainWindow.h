//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (MainWindow)

- (UIWindow *)jdsb_mainApplicationWindowIgnoringWindow:(UIWindow *)ignoringWindow;

- (UIViewController *)jdsb_mainControllerIgnoringViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
