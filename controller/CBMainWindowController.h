#import "Cocoa.h"
#import "CBViewDelegate.h"
#import "CBHotKeyDelegate.h"

@class CBClipboardLayer;
@class CBClipboard;
@class CBSettings;

@interface CBMainWindowController : NSObject
{
    @private
    NSWindow *mainWindow;
    NSArray *types;
    CALayer *rootLayer;
    CABasicAnimation *fadeIn;
    CABasicAnimation *fadeOut;
    BOOL mainLayerHidden;
}

- (id)initWithWindow:(NSWindow *)aWindow;

- (void)setFadeInDuration:(NSTimeInterval)time;

- (void)setFadeOutDuration:(NSTimeInterval)time;

- (CALayer *)rootLayer;

@end

@interface CBMainWindowController(Delegation) <CBHotKeyDelegate, CBViewDelegate>

- (void)hotKeyPressed:(CBHotKey *)hotKey;

- (void)view:(CBView *)aView didReceiveMouseDown:(NSEvent *)theEvent;

- (void)view:(CBView *)aView didReceiveMouseUp:(NSEvent *)theEvent;

- (void)view:(CBView *)aView didReceiveMouseDragged:(NSEvent *)theEvent;

- (void)animationDidStop:(CAAnimation *)theAnimation
                finished:(BOOL)flag;

- (id <CAAction>)actionForLayer:(CALayer *)layer
                         forKey:(NSString *)key;

@end