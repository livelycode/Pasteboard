#import "Cocoa.h"
#import "CBPasteboardObserver.h"
#import "CBHotKeyDelegate.h"

@class CBHotKey;
@class CBPasteboardObserver;
@class CBClipboardWindowController;

@interface CBApplicationController : NSObject 
{
    @private
    CBPasteboardObserver *clipboardObserver;
    CBHotKey *hotKey;
    CBClipboardWindowController *windowController;
    BOOL windowHidden;
}

- (id)init;

@end

@interface CBApplicationController(Delegation) <NSApplicationDelegate>

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;

@end