//
//

#import <UIKit/UIKit.h>

@class JDStatusBarStyle;
@class JDStatusBarNotificationViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol JDStatusBarWindowDelegate <NSObject>
- (void)didDismissStatusBar;
@end

@interface JDStatusBarWindow : UIWindow

@property (nonatomic, strong) JDStatusBarNotificationViewController *statusBarViewController;
@property (nonatomic, weak) id<JDStatusBarWindowDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

- (instancetype)initWithStyle:(JDStatusBarStyle *)style
                  windowScene:(UIWindowScene * _Nullable)windowScene;

@end

NS_ASSUME_NONNULL_END
