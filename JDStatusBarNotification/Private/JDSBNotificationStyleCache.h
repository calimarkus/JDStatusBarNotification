//
//

#import <Foundation/Foundation.h>

#import "JDStatusBarNotificationPresenterPrepareStyleBlock.h"
#import "JDStatusBarNotificationStyle.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(_SBNotificationStyleCache)
@interface JDSBNotificationStyleCache : NSObject

- (JDStatusBarNotificationStyle *)styleForName:(NSString *)styleName;
- (JDStatusBarNotificationStyle *)styleForIncludedStyle:(JDStatusBarNotificationIncludedStyle)style;

- (void)updateDefaultStyle:(NS_NOESCAPE JDStatusBarNotificationPresenterPrepareStyleBlock)prepareBlock;

- (NSString *)addStyleNamed:(NSString *)styleName
                    prepare:(NS_NOESCAPE JDStatusBarNotificationPresenterPrepareStyleBlock)prepareBlock;

- (NSString *)addStyleNamed:(NSString*)styleName
               basedOnStyle:(JDStatusBarNotificationIncludedStyle)basedOnStyle
                    prepare:(NS_NOESCAPE JDStatusBarNotificationPresenterPrepareStyleBlock)prepareBlock;

@end

NS_ASSUME_NONNULL_END
