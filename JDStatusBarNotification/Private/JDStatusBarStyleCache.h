//
//

#import <Foundation/Foundation.h>

#import "JDStatusBarPrepareStyleBlock.h"
#import "JDStatusBarStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface JDStatusBarStyleCache : NSObject

- (JDStatusBarStyle *)styleForName:(NSString *)styleName;
- (JDStatusBarStyle *)styleForIncludedStyle:(JDStatusBarIncludedStyle)style;

- (void)updateDefaultStyle:(NS_NOESCAPE JDStatusBarPrepareStyleBlock)prepareBlock;

- (NSString *)addStyleNamed:(NSString *)styleName
                    prepare:(NS_NOESCAPE JDStatusBarPrepareStyleBlock)prepareBlock;

@end

NS_ASSUME_NONNULL_END
