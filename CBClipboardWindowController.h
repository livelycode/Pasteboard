#import "Cocoa.h"

@class CBClipboardLayer;
@class CBClipboard;

@interface CBClipboardWindowController : NSObject
{
    @private
    NSWindow *mainWindow;
    NSArray *types;
    CALayer *mainLayer;
    CBClipboardLayer *clipboardLayer;
    CBClipboard *clipboard;
    CABasicAnimation *fadeIn;
    CABasicAnimation *fadeOut;
    BOOL mainLayerHidden;
}

- (id)init;

- (void)registerWindow;

- (void)setFadeInDuration:(CGFloat)aDuration;

- (void)setFadeOutDuration:(CGFloat)aDuration;

@end

@interface CBClipboardWindowController(Delegation) <CBPasteboardOberserverDelegate, CBHotKeyDelegate>

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag;

- (void)hotKeyPressed:(CBHotKey *)hotKey;

- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;

@end