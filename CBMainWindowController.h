#import "Cocoa.h"

@class CBClipboardLayer;
@class CBClipboard;
@class CBSettings;

@interface CBMainWindowController : NSObject
{
    @private
    NSWindow *mainWindow;
    NSArray *types;
    CALayer *mainLayer;
    CABasicAnimation *fadeIn;
    CABasicAnimation *fadeOut;
    BOOL mainLayerHidden;
}

- (id)init;

- (void)registerWindow;

@end

@interface CBMainWindowController(Delegation) <CBHotKeyDelegate>

- (void)hotKeyPressed:(CBHotKey *)hotKey;

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag;

@end