//
//

#import <Foundation/Foundation.h>

#import "JDStatusBarPrepareStyleBlock.h"
#import "JDStatusBarNotificationStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDStatusBarStyleCache : NSObject

- (JDStatusBarNotificationStyle *)styleForName:(NSString *)styleName;
- (JDStatusBarNotificationStyle *)styleForIncludedStyle:(JDStatusBarIncludedStyle)style;

- (void)updateDefaultStyle:(NS_NOESCAPE JDStatusBarPrepareStyleBlock)prepareBlock;

- (NSString *)addStyleNamed:(NSString *)styleName
                    prepare:(NS_NOESCAPE JDStatusBarPrepareStyleBlock)prepareBlock;

- (NSString *)addStyleNamed:(NSString*)styleName
               basedOnStyle:(JDStatusBarIncludedStyle)basedOnStyle
                    prepare:(NS_NOESCAPE JDStatusBarPrepareStyleBlock)prepareBlock;

@end

NS_ASSUME_NONNULL_END
