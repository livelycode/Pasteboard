#import "Cocoa.h"

@class CBClipboard;
@class CBClipboardView;

@interface CBClipboardController : NSObject
{
    @private
    CBClipboard *clipboard;
    CBClipboardView *clipboardView;
}
							
- (id)initWithClipboard:(CBClipboard *)aClipboard
                   view:(CBClipboardView *)aView;

- (void)updateItemViews;

@end