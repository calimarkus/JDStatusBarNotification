//
//

#import <UIKit/UIKit.h>

@class JDSBNotificationView;
@class JDStatusBarNotificationStyle;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ _Nullable JDSBNotificationViewControllerCompletion)(void) NS_SWIFT_NAME(_SBNotificationViewControllerCompletion);

NS_SWIFT_NAME(_SBNotificationViewControllerDelegate)
@protocol JDSBNotificationViewControllerDelegate
- (void)didDismissStatusBar;
@end

NS_SWIFT_NAME(_SBNotificationViewController)
@interface JDSBNotificationViewController : UIViewController

@property (nonatomic, strong, readonly) JDSBNotificationView *statusBarView;
@property (nonatomic, weak) id<JDSBNotificationViewControllerDelegate> delegate;
@property (nonatomic, weak) UIWindow *jdsb_window;

- (JDSBNotificationView *)presentWithStyle:(JDStatusBarNotificationStyle *)style
                                completion:(JDSBNotificationViewControllerCompletion)completion;

- (void)dismissWithDuration:(CGFloat)duration
                 afterDelay:(NSTimeInterval)delay
                 completion:(JDSBNotificationViewControllerCompletion)completion;

@end

NS_ASSUME_NONNULL_END
