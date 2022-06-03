//
//

#import <UIKit/UIKit.h>

@class JDStatusBarView;
@class JDStatusBarStyle;

NS_ASSUME_NONNULL_BEGIN

@protocol JDStatusBarNotificationViewControllerDelegate
- (void)animationsForViewTransitionToSize:(CGSize)size;
@end

@interface JDStatusBarNotificationViewController : UIViewController

@property (nonatomic, strong, readonly) JDStatusBarView *statusBarView;
@property (nonatomic, weak) id<JDStatusBarNotificationViewControllerDelegate> delegate;

- (instancetype)initWithStyle:(JDStatusBarStyle *)style;

@end

NS_ASSUME_NONNULL_END
