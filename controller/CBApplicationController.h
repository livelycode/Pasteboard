#import "Cocoa.h"
#import "CBPasteboardObserver.h"

@class CBClipboard;
@class CBClipboardController;
@class CBHotKeyObserver;
@class CBPasteboardObserver;
@class CBMainWindowController;
@class HTTPConnectionDelegate;
@class CBSyncController;

@interface CBApplicationController : NSObject 
{
    @private
    CBPasteboardObserver *pasteboardObserver;		
    CBHotKeyObserver *hotKey;
    CBClipboard *leftClipboard;
    CBClipboardController *historyClipboardController;
    CBClipboardController *syncingClipboardController;
    CBMainWindowController *windowController;
    CBClipboardController *clipboardController;
    CBSyncController *syncController;
    HTTPConnectionDelegate *connectionDelegate;
    NSArray *pasteboardClasses;
    BOOL windowHidden;
}
- (void)initClipboards;
- (void)initPasteboardObserver;
- (void)addSubview: (NSView*) view;
- (void)startSyncing;
@end

@interface CBApplicationController(Delegation) <NSApplicationDelegate, CBPasteboardOberserverDelegate>
//NSApplicationDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;

//CBPasteboardOberserverDelegate
- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;

@end