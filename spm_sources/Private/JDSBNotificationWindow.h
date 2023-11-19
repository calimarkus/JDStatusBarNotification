//
//

#import <UIKit/UIKit.h>

@class JDSBNotificationViewController;

NS_ASSUME_NONNULL_BEGIN

NS_REFINED_FOR_SWIFT
@protocol JDSBNotificationWindowDelegate <NSObject>
- (void)didDismissStatusBar;
@end

NS_REFINED_FOR_SWIFT
@interface JDSBNotificationWindow : UIWindow

@property (nonatomic, strong) JDSBNotificationViewController *statusBarViewController;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

- (instancetype)initWithWindowScene:(UIWindowScene * _Nullable)windowScene
                           delegate:(id<JDSBNotificationWindowDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
