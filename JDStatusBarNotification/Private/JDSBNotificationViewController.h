//
//

#import <UIKit/UIKit.h>

@class JDSBNotificationView;
@class JDStatusBarNotificationStyle;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ _Nullable JDSBNotificationViewControllerCompletion)(void) NS_REFINED_FOR_SWIFT;

NS_REFINED_FOR_SWIFT
@protocol JDSBNotificationViewControllerDelegate
- (void)didDismissStatusBar;
@end

NS_REFINED_FOR_SWIFT
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
