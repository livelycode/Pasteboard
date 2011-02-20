#import "Cocoa.h"
#import "CBClipboardViewDelegate.h"

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

@interface CBClipboardController(Delegation) <CBPasteboardOberserverDelegate, CBClipboardViewDelegate>

- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;

- (void)didReceiveClickForItemAtIndex:(NSUInteger)anIndex;

- (void)didReceiveDismissClickFirItemAtIndex:(NSUInteger)anIndex;

@end