#import "Cocoa.h"

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

@interface CBMainWindowController(Delegation) <CBHotKeyDelegate>

- (void)hotKeyPressed:(CBHotKey *)hotKey;

- (void)animationDidStop:(CAAnimation *)theAnimation
                finished:(BOOL)flag;

- (id <CAAction>)actionForLayer:(CALayer *)layer
                         forKey:(NSString *)key;

@end