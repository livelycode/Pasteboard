#import "Cloudboard.h"

static CBSettings *sharedSettings = nil;

@implementation CBSettings

+ (CBSettings *)sharedSettings
{
    if (sharedSettings == nil)
    {
        sharedSettings = [[self alloc] init];
    }
    return sharedSettings;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        NSString *settingsPath = [[NSBundle mainBundle] pathForResource:@"Settings"
                                                                 ofType:@"plist"];
        settings = [NSDictionary dictionaryWithContentsOfFile:settingsPath];
    }
    return self;
}

- (CGFloat)floatForKey:(NSString *)aKey
{
    return [[settings objectForKey:aKey] floatValue];
}

- (NSInteger)integerForKey:(NSString *)aKey
{
    return [[settings objectForKey:aKey] integerValue];
}


@end