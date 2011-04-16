#import "Cocoa.h"
#import "CBHotKeyObserverDelegate.h"

@class CBWindowView;
@class CBSyncController;
@class CBSettingsController;

@interface CBMainWindowController : NSObject {
  @private
  CBWindow *mainWindow;
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
- (void)toggleVisibility;
- (id)initWithFrontView:(id)theFront backView:(id)theBack;
- (void)showFront;
- (void)showBack;
- (CBClipboardController *)clipboardController;
@end

@interface CBMainWindowController(Delegation) <CBHotKeyObserverDelegate>
- (void)hotKeyPressed:(CBHotKeyObserver *)hotKey;
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag;
@end

@interface CBMainWindowController(Private)
- (CATransform3D)createFlipTransform;
- (CBWindowView *)rootViewWithFrame:(CGRect)aRect front:(NSView *)frontView back:(NSView *)backView;
- (CGRect)createClipboardFrame;
- (CALayer *)layerWithFront:(NSView *)theFront back:(NSView *)theBack;
- (NSDictionary *)actions;
@end