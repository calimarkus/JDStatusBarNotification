//
//

#import <UIKit/UIKit.h>

@class JDSBNotificationView;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ _Nullable JDSBNotificationAnimatorCompletion)(void) NS_SWIFT_NAME(_SBNotificationAnimatorCompletion);

NS_SWIFT_NAME(_SBNotificationAnimator)
@interface JDSBNotificationAnimator : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithStatusBarView:(JDSBNotificationView *)statusBarView;

- (void)animateInWithDuration:(CGFloat)duration
                   completion:(JDSBNotificationAnimatorCompletion)completion;

- (void)animateOutWithDuration:(CGFloat)duration
                    completion:(JDSBNotificationAnimatorCompletion)completion;

@end

NS_ASSUME_NONNULL_END
