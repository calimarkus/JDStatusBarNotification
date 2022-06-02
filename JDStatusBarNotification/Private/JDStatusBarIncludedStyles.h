//
//

#import <Foundation/Foundation.h>

@class JDStatusBarStyle;

NS_ASSUME_NONNULL_BEGIN

@interface JDStatusBarIncludedStyles : NSObject

+ (JDStatusBarStyle *)defaultStyle;
+ (JDStatusBarStyle * _Nullable)defaultStyleWithName:(NSString *)styleName;

@end

NS_ASSUME_NONNULL_END
