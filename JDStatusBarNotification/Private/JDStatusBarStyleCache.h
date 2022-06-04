//
//

#import <Foundation/Foundation.h>

#import "JDStatusBarPrepareStyleBlock.h"

@class JDStatusBarStyle;

NS_ASSUME_NONNULL_BEGIN

@interface JDStatusBarStyleCache : NSObject

- (JDStatusBarStyle *)styleForName:(NSString *)styleName;

- (void)updateDefaultStyle:(JDStatusBarPrepareStyleBlock)prepareBlock;

- (NSString *)addStyleNamed:(NSString *)styleName
                    prepare:(JDStatusBarPrepareStyleBlock)prepareBlock;

@end

NS_ASSUME_NONNULL_END
