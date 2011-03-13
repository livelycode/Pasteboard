#import "Cocoa.h"
#import "CBHotKeyObserverDelegate.h"

@class CBWindowView;
@class CBSyncController;
@class CBSettingsController;

@interface CBMainWindowController : NSObject {
  @private
  NSWindow *mainWindow;
  CBWindowView *rootView;
  CBClipboardController *clipboardController;
  CBSettingsController *settingsController;
  CBSyncController *syncController;
  NSView *frontView;
  NSView *backView;
  CALayer *flipLayer;
  NSString *flipKey;
  BOOL isFlipped;
}

+ (void)addSublayerToRootLayer:(CALayer *)aLayer;

- (id)initWithFrontView:(NSView *)theFront backView:(NSView *)theBack;
- (void)showFront;
- (void)showBack;
- (CBClipboardController *)clipboardController;

@end

@interface CBMainWindowController(Delegation) <CBHotKeyObserverDelegate>

- (void)hotKeyPressed:(CBHotKeyObserver *)hotKey;
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag;

@end