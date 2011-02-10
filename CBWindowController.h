#import "Cocoa.h"

@class CBClipboard;

@interface CBWindowController : NSObject
{
    @private
    
    NSWindow *mainWindow;
    CALayer *mainLayer;
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

@interface CBWindowController(Delegation) <CBPasteboardOberserverDelegate, CBHotKeyDelegate>

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag;

- (void)hotKeyPressed:(CBHotKey *)hotKey;

- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;

@end