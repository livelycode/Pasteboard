#import "Cocoa.h"
#import "CBPasteboardObserver.h"
#import "CBHotKeyDelegate.h"

@class CBClipboard;
@class CBClipboardController;
@class CBHotKey;
@class CBPasteboardObserver;
@class CBMainWindowController;

@interface CBApplicationController : NSObject 
{
    @private
    CBPasteboardObserver *pasteboardObserver;
    CBHotKey *hotKey;
    CBClipboard *leftClipboard;
    CBClipboardController *leftClipboardController;
    CBMainWindowController *windowController;
    BOOL windowHidden;
}

@end

@interface CBApplicationController(Delegation) <NSApplicationDelegate, CBPasteboardOberserverDelegate>

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;

- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;

@end