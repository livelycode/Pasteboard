#import "Cocoa.h"

@interface CBClipboardLayer : NSObject
{
    @private
    CALayer *mainLayer;
    CGRect frame;
}

- (id)initWithFrame:(CGRect)aRect;

- (void)setCornerRadius:(CGFloat)aRadius;

- (void)setOpacity:(CGFloat)anOpacity;

- (CALayer *)layer;

@end