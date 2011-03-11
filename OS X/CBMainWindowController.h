#import "Cocoa.h"
#import "CBHotKeyObserverDelegate.h"

@class CBWindowView;
@class CBSyncController;
@class CBSettingsController;

@interface CBMainWindowController : NSObject {
  @private
  NSArray *types;
  NSWindow *mainWindow;
  CBWindowView *rootView;
  NSView *animationView;
  CBClipboardController *clipboardController;
  CBSettingsController *settingsController;
  CBSyncController *syncController;
  NSView *front;
  NSView *back;
}

- (id)initWithFrontView:(NSView *)theFront backView:(NSView *)theBack;
- (void)showFront;
- (void)showBack;
- (void)addSublayerToRootLayer:(CALayer *)aLayer;
- (CBClipboardController *)clipboardController;

@end

@interface CBMainWindowController(Delegation) <CBHotKeyObserverDelegate>

- (void)hotKeyPressed:(CBHotKeyObserver *)hotKey;

@end