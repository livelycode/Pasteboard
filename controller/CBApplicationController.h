#import "Cocoa.h"
#import "CBPasteboardObserver.h"

@class CBClipboard;
@class CBClipboardController;
@class CBHotKeyObserver;
@class CBPasteboardObserver;
@class CBMainWindowController;
@class HTTPConnectionDelegate;

@interface CBApplicationController : NSObject 
{
    @private
    CBPasteboardObserver *pasteboardObserver;		
    CBHotKeyObserver *hotKey;
    CBClipboard *leftClipboard;
    CBClipboardController *leftClipboardController;
    CBClipboardController *rightClipboardController;
    CBMainWindowController *windowController;
    CBClipboardController *clipboardController;
    HTTPConnectionDelegate *connectionDelegate;
    BOOL windowHidden;
}
- (void)addSubview: (NSView*) view;
@end

@interface CBApplicationController(Delegation) <NSApplicationDelegate>

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;
- (void)launchHTTPServer;
- (void)startSyncing;


@end