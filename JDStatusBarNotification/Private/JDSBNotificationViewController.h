//
//

#import <UIKit/UIKit.h>

@class JDSBNotificationView;
@class JDStatusBarNotificationStyle;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ _Nullable JDSBNotificationViewControllerCompletion)(void) NS_SWIFT_NAME(_SBNotificationViewControllerCompletion);

NS_SWIFT_NAME(_SBNotificationViewControllerDelegate)
@protocol JDSBNotificationViewControllerDelegate
- (void)animationsForViewTransitionToSize:(CGSize)size;
- (void)didDismissStatusBar;
- (void)didUpdateStyle;
@end

NS_SWIFT_NAME(_SBNotificationViewController)
@interface JDSBNotificationViewController : UIViewController

@property (nonatomic, strong, readonly) JDSBNotificationView *statusBarView;
@property (nonatomic, weak) id<JDSBNotificationViewControllerDelegate> delegate;

- (JDSBNotificationView *)presentWithTitle:(NSString * _Nullable)title
                             subtitle:(NSString * _Nullable)subtitle
                                style:(JDStatusBarNotificationStyle *)style
                           completion:(JDSBNotificationViewControllerCompletion)completion;

- (void)dismissAfterDelay:(NSTimeInterval)delay
               completion:(JDSBNotificationViewControllerCompletion)completion;

- (void)dismissWithDuration:(CGFloat)duration
                 completion:(JDSBNotificationViewControllerCompletion)completion;

@end

NS_ASSUME_NONNULL_END
