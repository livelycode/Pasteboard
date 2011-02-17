#import "Cocoa.h"
#import "CBHotKeyObserverDelegate.h"

@interface CBMainWindowController : NSObject
{
    @private
    NSArray *types;
    NSWindow *mainWindow;
    NSView *rootView;
}

- (id)init;

- (NSView *)rootView;

@end

@interface CBMainWindowController(Delegation) <CBHotKeyObserverDelegate>

- (void)hotKeyPressed:(CBHotKeyObserver *)hotKey;

@end