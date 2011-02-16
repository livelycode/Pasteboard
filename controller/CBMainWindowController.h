#import "Cocoa.h"
#import "CBHotKeyDelegate.h"

@interface CBMainWindowController : NSObject
{
    @private
    NSArray *types;
    NSWindow *mainWindow;
    CBView *rootView;
}

- (id)init;

- (NSView *)rootView;

@end

@interface CBMainWindowController(Delegation) <CBHotKeyObserverDelegate>

- (void)hotKeyPressed:(CBHotKeyObserver *)hotKey;

@end