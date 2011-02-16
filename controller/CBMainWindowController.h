#import "Cocoa.h"
#import "CBViewDelegate.h"
#import "CBHotKeyDelegate.h"

@class CBClipboardLayer;
@class CBClipboard;
@class CBSettings;
@class CBView;

@interface CBMainWindowController : NSObject
{
    @private
    NSArray *types;
    NSWindow *mainWindow;
    CBView *rootView;
    CABasicAnimation *fadeIn;
    CABasicAnimation *fadeOut;
    BOOL mainLayerHidden;
}

- (id)init;

- (void)setFadeInDuration:(NSTimeInterval)time;

- (void)setFadeOutDuration:(NSTimeInterval)time;

- (NSView *)rootView;

@end

@interface CBMainWindowController(Delegation) <CBHotKeyObserverDelegate, CBViewDelegate>

- (void)hotKeyPressed:(CBHotKeyObserver *)hotKey;

@end