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
    NSArray *pasteboardClasses;
    BOOL windowHidden;
}
- (void)initClipboards;
- (void)initPasteboardObserver;
- (void)addSubview: (NSView*) view;
- (void)launchHTTPServer;
- (void)startSyncing;
@end

@interface CBApplicationController(Delegation) <NSApplicationDelegate, CBPasteboardOberserverDelegate>
//NSApplicationDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;

//CBPasteboardOberserverDelegate
- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;

@end