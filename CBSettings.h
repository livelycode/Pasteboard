#import "Cocoa.h"

@interface CBSettings : NSObject
{
    @private
    NSDictionary *settings;
}

+ (CBSettings *)sharedSettings;

- (id)init;

- (CGFloat)floatForKey:(NSString *)aKey;

- (NSInteger)integerForKey:(NSString *)aKey;

@end