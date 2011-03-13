#import "Cloudboard.h"

static CALayer *rootLayer;

@implementation CBMainWindowController(Private)

- (CBWindowView *)createRootViewWithFrame:(CGRect)aRect {
  CBWindowView *view = [[CBWindowView alloc] initWithFrame:aRect];
  rootLayer = [CALayer layer];
  [rootLayer setBackgroundColor:CGColorCreateGenericGray(0, 0.4)];
  [view setLayer:rootLayer];
  [view setWantsLayer:YES];	
  return view;
}

- (NSWindow *)createWindowWithFrame:(CGRect)aRect {
  NSWindow *window = [[NSWindow alloc] initWithContentRect:aRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
  [window setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
  [window setLevel:NSStatusWindowLevel];
  [window setOpaque:NO];
  [window setBackgroundColor:[NSColor clearColor]];
  return window;
}

- (CGRect)createClipboardFrame {
  CGRect mainFrame = [[NSScreen mainScreen] frame];
  CGFloat screenHeight = CGRectGetHeight(mainFrame);
  CGFloat screenWidth = CGRectGetWidth(mainFrame);
  CGFloat marginSide = 40;
  CGFloat marginBottom = 50;
  CGFloat clipboardHeight = screenHeight - (2 * marginBottom);
  CGFloat clipboardWidth = (screenWidth - (3 * marginSide)) / 2;
  return CGRectMake((screenWidth-clipboardWidth)/2, marginBottom, clipboardWidth, clipboardHeight);
}

- (CATransform3D)createFlipTransform {
  CATransform3D transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
  transform.m34 = 0.0005;
  return transform;
}

- (CALayer *)createFlipLayer {
  [CATransaction setDisableActions:YES];
  CALayer *frontLayer = [clipboardController snapShot];
  [frontLayer setDoubleSided:NO];
  CALayer *backLayer = [settingsController snapShot];
  [backLayer setTransform:[self createFlipTransform]];
  CALayer *layer = [CALayer layer];
  [layer setFrame:[front frame]];
  [layer addSublayer:backLayer];
  [layer addSublayer:frontLayer];
  [CATransaction setDisableActions:NO];
  return layer;
}

- (CABasicAnimation *)createFlipAnimation {
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
  [animation setDelegate:self];
  [animation setDuration:0.8];
  if (isFlipped) {
    [animation setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    [animation setToValue:[NSValue valueWithCATransform3D:[self createFlipTransform]]];
  } else {
    [animation setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    [animation setFromValue:[NSValue valueWithCATransform3D:[self createFlipTransform]]];
  }
  return animation;
}

@end

@implementation CBMainWindowController(Delegation)

- (void)hotKeyPressed:(CBHotKeyObserver *)hotKey {
  if ([mainWindow isVisible]) {
    [mainWindow orderOut:self];
  } else {
    [mainWindow makeKeyAndOrderFront:self];
  }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
  if (isFlipped) {
    [rootView addSubview:back];
  } else {
    [rootView addSubview:front];
  }
  [flipLayer removeFromSuperlayer];
}

@end

@implementation CBMainWindowController

+ (void)addSublayerToRootLayer:(CALayer *)aLayer {
  [rootLayer addSublayer:aLayer];
}

- (id)initWithFrontView:(NSView *)theFront backView:(NSView *)theBack {
  self = [super init];
  if (self != nil) {
    isFlipped = NO;
    CGRect mainFrame = [[NSScreen mainScreen] frame];
    CGRect clipboardFrame = [self createClipboardFrame];
    mainWindow = [self createWindowWithFrame:mainFrame];
    rootView = [self createRootViewWithFrame:mainFrame];
    [mainWindow setContentView:rootView];
    clipboardController = [[CBClipboardController alloc] initWithFrame:clipboardFrame];
    [clipboardController setWindowController:self];
    syncController = [[CBSyncController alloc] initWithClipboardController:clipboardController];
    [clipboardController setSyncController:syncController];
    settingsController = [[CBSettingsController alloc] initWithFrame:clipboardFrame syncController:syncController];
    [settingsController setWindowController:self];
    front = [clipboardController view];
    back = [settingsController view];
    [rootView addSubview:front];
  }
  return self;
}

- (void)showFront {
  isFlipped = NO;
  [CBMainWindowController addSublayerToRootLayer:flipLayer];
  [back removeFromSuperview];
  [flipLayer setTransform:CATransform3DIdentity];
  [flipLayer addAnimation:[self createFlipAnimation] forKey:@"transform"];
}

- (void)showBack {
  isFlipped = YES;
  flipLayer = [self createFlipLayer];
  [CBMainWindowController addSublayerToRootLayer:flipLayer];
  [front removeFromSuperview];
  [flipLayer setTransform:[self createFlipTransform]];
  [flipLayer addAnimation:[self createFlipAnimation] forKey:@"transform"];
}

- (CBClipboardController *)clipboardController {
  return clipboardController;
}

@end

