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
							
- (id)initWithFrame:(CGRect)frame delegate: (id)delegate;

@end

@interface CBClipboardController(Delegation) <CBPasteboardOberserverDelegate>

- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;

@end