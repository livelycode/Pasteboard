#import "Cocoa.h"

@class CBClipboard;
@class CBClipboardLayer;

@interface CBClipboardController : NSObject
{
    @private
    CBClipboard *clipboard;
    CBClipboardLayer *clipboardLayer;
    NSArray *types;
}
							
- (id)initWithClipboard:(CBClipboard *)aClipboard
                  layer:(CBClipboardLayer *)aLayer;

- (void)setTypes:(NSArray *)anArray;

- (void)updateItemLayers;

@end