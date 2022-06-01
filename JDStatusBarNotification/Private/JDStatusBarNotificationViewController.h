//
//

#import <UIKit/UIKit.h>

#import "JDStatusBarStyle.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JDStatusBarNotificationViewControllerDelegate
- (void)animationsForViewTransitionToSize:(CGSize)size;
@end

@interface JDStatusBarNotificationViewController : UIViewController

@property (nonatomic, assign) JDStatusBarSystemStyle statusBarSystemStyle;

@property (nonatomic, weak) id<JDStatusBarNotificationViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
