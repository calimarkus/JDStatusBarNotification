//
//

#import <UIKit/UIKit.h>

@class JDStatusBarNotificationStyle;
@class JDSBNotificationViewController;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(_SBNotificationWindowDelegate)
@protocol JDSBNotificationWindowDelegate <NSObject>
- (void)didDismissStatusBar;
@end

NS_SWIFT_NAME(_SBNotificationWindow)
@interface JDSBNotificationWindow : UIWindow

@property (nonatomic, strong) JDSBNotificationViewController *statusBarViewController;
@property (nonatomic, weak) id<JDSBNotificationWindowDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

- (instancetype)initWithStyle:(JDStatusBarNotificationStyle *)style
                  windowScene:(UIWindowScene * _Nullable)windowScene;

@end

NS_ASSUME_NONNULL_END
