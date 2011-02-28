#import "Cocoa.h"
#import "CBHotKeyObserverDelegate.h"

@class CBWindowView;;

@interface CBMainWindowController : NSObject
{
    @private
    NSArray *types;
    NSWindow *mainWindow;
    CBWindowView *rootView;
}

- (id)init;

- (NSView *)rootView;

@end

@interface CBMainWindowController(Delegation) <CBHotKeyObserverDelegate>

- (void)hotKeyPressed:(CBHotKeyObserver *)hotKey;

@end