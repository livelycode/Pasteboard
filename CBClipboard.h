#import "Cocoa.h"
#import "CBClipboardDelegate.h"

@interface CBClipboard : NSObject
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