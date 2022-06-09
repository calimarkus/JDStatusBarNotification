//
//

#import <UIKit/UIKit.h>

@class JDStatusBarView;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ _Nullable JDStatusBarAnimatorCompletion)(void);

@interface JDStatusBarAnimator : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithStatusBarView:(JDStatusBarView *)statusBarView;

- (void)animateInWithDuration:(CGFloat)duration
                   completion:(JDStatusBarAnimatorCompletion)completion;

- (void)animateOutWithDuration:(CGFloat)duration
                    completion:(JDStatusBarAnimatorCompletion)completion;

@end

NS_ASSUME_NONNULL_END
