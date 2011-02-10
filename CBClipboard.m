#import "Cloudboard.h"

@implementation CBClipboard

- (id)initWithFrame:(CGRect)aRect;
{
    self = [super init];
    if (self != nil)
    {
        frame = aRect;
        mainLayer = [CALayer layer];
        [mainLayer setFrame:aRect];
        [mainLayer setActions:[NSDictionary dictionaryWithObject:[NSNull null]
                                                             forKey:@"opacity"]];
    }
    return self;
}

- (void)setCornerRadius:(CGFloat)aRadius
{
    [mainLayer setCornerRadius:aRadius];
}

- (void)setOpacity:(CGFloat)anOpacity
{
    CGColorRef color = CGColorCreateGenericGray(0, anOpacity);
    [mainLayer setBackgroundColor:color];
    CFRelease(color);
}

- (CALayer *)layer
{
    return mainLayer;
}

@end