#import "Cocoa.h"
#import "CBPasteboardObserver.h"
#import "CBHotKeyDelegate.h"

@class CBClipboardController;
@class CBHotKey;
@class CBPasteboardObserver;
@class CBMainWindowController;

@interface CBApplicationController : NSObject 
{
    @private
    CBPasteboardObserver *pasteboardObserver;
    CBHotKey *hotKey;
    CBMainWindowController *windowController;
    CBClipboardController *clipboardController;
    BOOL windowHidden;
}

@end

@interface CBApplicationController(Delegation) <NSApplicationDelegate>

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;

@end