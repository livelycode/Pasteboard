#import "Cocoa.h"
#import "CBPasteboardObserver.h"
#import "CBSyncControllerProtocol.h"

@class CBClipboard;
@class CBClipboardController;
@class CBHotKeyObserver;
@class CBPasteboardObserver;
@class CBMainWindowController;
@class CBPreferencesController;
@class HTTPConnectionDelegate;
@class CBSyncController;

@interface CBApplicationController : NSObject 
{
    @private
    CBPasteboardObserver *pasteboardObserver;		
    CBHotKeyObserver *hotKey;
    CBClipboardController *historyClipboardController;
    CBClipboardController *syncingClipboardController;
    CBMainWindowController *windowController;
    CBPreferencesController *preferencesController;
    CBClipboardController *clipboardController;
    CBSyncController *syncController;
    NSArray *pasteboardClasses;
    BOOL windowHidden;
}
- (void)initClipboards;
- (void)initPasteboardObserver;
- (void)addSubview: (NSView*) view;
- (void)startSyncing;
- (void)openPreferences;
- (CBSyncController*)syncController;
@end

@interface CBApplicationController(Delegation)
  <NSApplicationDelegate, CBPasteboardOberserverDelegate, CBSyncControllerProtocol>
//NSApplicationDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;

//CBPasteboardOberserverDelegate
- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;

//CBSyncControllerDelegate
- (void)clientRequiresUserConfirmation:(NSString*)clientName;

@end