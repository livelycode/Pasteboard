#import "Cocoa.h"
#import "CBPasteboardObserver.h"
#import "CBHotKeyDelegate.h"

@class CBClipboard;
@class CBClipboardController;
@class CBHotKey;
@class CBPasteboardObserver;
@class CBMainWindowController;
@class HTTPConnectionDelegate;

@interface CBApplicationController : NSObject 
{
    @private
    CBPasteboardObserver *pasteboardObserver;		
    CBHotKey *hotKey;
    CBClipboard *leftClipboard;
    CBClipboardController *leftClipboardController;
    CBMainWindowController *windowController;
    CBClipboardController *clipboardController;
    HTTPConnectionDelegate *connectionDelegate;
    BOOL windowHidden;
}

@end

@interface CBApplicationController(Delegation) <NSApplicationDelegate, CBPasteboardOberserverDelegate>

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
- (void)launchHTTPServer;

- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;

@end