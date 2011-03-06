#import "Cocoa.h"
#import "CBPasteboardObserver.h"
#import "CBSyncControllerProtocol.h"

@class CBClipboard, CBClipboardController, CBItem, CBHotKeyObserver, CBPasteboardObserver, CBMainWindowController, CBPreferencesController, HTTPConnectionDelegate, CBSyncController;

@interface CBApplicationController : NSObject 
{
    @private
    CBPasteboardObserver *pasteboardObserver;		
    CBHotKeyObserver *hotKey;
    CBClipboardController *clipboardController;
    CBMainWindowController *windowController;
    CBPreferencesController *preferencesController;
    CBSyncController *syncController;
    NSArray *pasteboardClasses;
    BOOL windowHidden;
}
- (void)initClipboard;
- (void)initPasteboardObserver;
- (void)addSubview: (NSView*) view;
- (void)startSyncing;
- (void)openPreferences;
- (CBItem*)currentPasteboardItem;
- (CBSyncController*)syncController;
@end

@interface CBApplicationController(Delegation)
  <NSApplicationDelegate, CBPasteboardOberserverDelegate, CBSyncControllerProtocol>
//NSApplicationDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;

//CBPasteboardOberserverDelegate
- (void)systemPasteboardDidChange;

//CBSyncControllerDelegate
- (void)clientRequiresUserConfirmation:(NSString*)clientName;

@end