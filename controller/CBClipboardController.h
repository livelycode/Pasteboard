#import "Cocoa.h"

@class CBClipboard;
@class CBClipboardView;

@interface CBClipboardController : NSObject
{
    @private
    CBClipboard *clipboard;
    CBClipboardView *clipboardView;
    NSArray *classes;
}
							
- (id)initWithClipboard:(CBClipboard *)aClipboard
                   view:(CBClipboardView *)aView;

@end

@interface CBClipboardController(Delegation) <CBPasteboardOberserverDelegate>

- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;

@end