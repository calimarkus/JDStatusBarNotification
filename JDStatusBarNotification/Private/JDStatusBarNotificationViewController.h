//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JDStatusBarNotificationViewControllerDelegate
- (void)animationsForViewTransitionToSize:(CGSize)size;
@end

@interface JDStatusBarNotificationViewController : UIViewController

@property (nonatomic, weak) id<JDStatusBarNotificationViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
