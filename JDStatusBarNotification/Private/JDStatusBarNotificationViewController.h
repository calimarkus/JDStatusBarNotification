//
//

#import <UIKit/UIKit.h>

@class JDStatusBarView;
@class JDStatusBarNotificationStyle;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ _Nullable JDStatusBarNotificationViewControllerCompletion)(void);

@protocol JDStatusBarNotificationViewControllerDelegate
- (void)animationsForViewTransitionToSize:(CGSize)size;
- (void)didDismissStatusBar;
- (void)didUpdateStyle;
@end

@interface JDStatusBarNotificationViewController : UIViewController

@property (nonatomic, strong, readonly) JDStatusBarView *statusBarView;
@property (nonatomic, weak) id<JDStatusBarNotificationViewControllerDelegate> delegate;

- (JDStatusBarView *)presentWithTitle:(NSString * _Nullable)title
                             subtitle:(NSString * _Nullable)subtitle
                                style:(JDStatusBarNotificationStyle *)style
                           completion:(JDStatusBarNotificationViewControllerCompletion)completion;

- (void)dismissAfterDelay:(NSTimeInterval)delay
               completion:(JDStatusBarNotificationViewControllerCompletion)completion;

- (void)dismissWithDuration:(CGFloat)duration
                 completion:(JDStatusBarNotificationViewControllerCompletion)completion;

@end

NS_ASSUME_NONNULL_END
