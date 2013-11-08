#import <Foundation/Foundation.h>


@interface FTFontDescriptor : NSObject

@property (readonly) NSString *postscriptName;
@property (readonly) NSString *displayName;
@property (readonly) NSArray *familyMembers;
@property (readonly) BOOL hasFamilyMembers;

+ (NSArray *)fontFamilies;

- (instancetype)descriptorWithPostscriptName:(NSString *)postscriptName;

@end
