#import "Cocoa.h"
#import "CBPasteboardObserver.h"
#import "CBHotKeyDelegate.h"

@class CBHotKey;
@class CBPasteboardObserver;
@class CBWindowController;

@interface CBApplicationController : NSObject 
{
    @private
    
    CBPasteboardObserver *clipboardObserver;
    CBHotKey *hotKey;
    CBWindowController *windowController;
    BOOL windowHidden;
}

- (id)init;

@end

@interface CBApplicationController(Delegation) <NSApplicationDelegate>

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;

@end