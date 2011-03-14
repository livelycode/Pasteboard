#import "Cloudboard.h"

static CALayer *rootLayer;

@interface CBMainWindowController(Private)

- (CATransform3D)createFlipTransform;
- (CBWindowView *)createRootViewWithFrame:(CGRect)aRect front:(NSView *)frontView back:(NSView *)backView;
- (NSWindow *)createWindowWithFrame:(CGRect)aRect;
- (CGRect)createClipboardFrame;
- (CALayer *)createLayerWithFront:(NSView *)theFront back:(NSView *)theBack;
- (NSDictionary *)createActions;
- (CGImageRef)CGImageWithView:(NSView *)aView;

@end

@implementation CBMainWindowController

+ (void)addSublayerToRootLayer:(CALayer *)aLayer {
  [rootLayer addSublayer:aLayer];
}

- (id)initWithFrontView:(NSView *)theFront backView:(NSView *)theBack {
  self = [super init];
  if (self != nil) {
    isFlipped = NO;
    flipKey = @"transform";
    CGRect mainFrame = [[NSScreen mainScreen] frame];
    CGRect clipboardFrame = [self createClipboardFrame];
    mainWindow = [self createWindowWithFrame:mainFrame];
    clipboardController = [[CBClipboardController alloc] initWithFrame:clipboardFrame];
    [clipboardController setWindowController:self];
    syncController = [[CBSyncController alloc] initWithClipboardController:clipboardController];
    [clipboardController setSyncController:syncController];
    settingsController = [[CBSettingsController alloc] initWithFrame:clipboardFrame syncController:syncController];
    [settingsController setWindowController:self];
    frontView = [clipboardController view];
    backView = [settingsController view];
    [mainWindow setContentView:[self createRootViewWithFrame:mainFrame front:frontView back:backView]];
  }
  return self;
}

- (void)showFront {
  flipLayer = [self createLayerWithFront:backView back:frontView];
  [CATransaction setDisableActions:YES];
  [CBMainWindowController addSublayerToRootLayer:flipLayer];
  [CATransaction setDisableActions:NO];
  [backView setHidden:YES];
  [flipLayer setTransform:[self createFlipTransform]];
}

- (void)showBack {
  flipLayer = [self createLayerWithFront:frontView back:backView];
  [CATransaction setDisableActions:YES];
  [CBMainWindowController addSublayerToRootLayer:flipLayer];
  [CATransaction setDisableActions:NO];
  [frontView setHidden:YES];
  [flipLayer setTransform:[self createFlipTransform]];
}

- (CBClipboardController *)clipboardController {
  return clipboardController;
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
    [frontView setHidden:NO];
    
    isFlipped = NO;
  } else {
    [backView setHidden:NO];
    isFlipped = YES;
  }
  [CATransaction setDisableActions:YES];
  [flipLayer removeFromSuperlayer];
  [CATransaction setDisableActions:NO];
}

@end

@implementation CBMainWindowController(Private)

- (CATransform3D)createFlipTransform {
  CATransform3D transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
  transform.m34 = 0.0005;
  return transform;
}

- (CBWindowView *)createRootViewWithFrame:(CGRect)aRect front:(NSView *)theFront back:(NSView *)theBack {
  NSView *animationView = [[NSView alloc] initWithFrame:aRect];
  rootLayer = [CALayer layer];
  [animationView setLayer:rootLayer];
  [animationView setWantsLayer:YES];
  CBWindowView *view = [[CBWindowView alloc] initWithFrame:aRect];
  [view setColor:[NSColor colorWithCalibratedWhite:0 alpha:0.4]];
  [view setWantsLayer:YES];
  [view setSubviews:[NSArray arrayWithObjects:theBack, theFront, animationView, nil]];
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

- (CALayer *)createLayerWithFront:(NSView *)theFront back:(NSView *)theBack {
  CALayer *frontLayer = [[CALayer alloc] init];
  [frontLayer setFrame:[theFront bounds]];
  [frontLayer setContents:(id)[self CGImageWithView:theFront]];
  [frontLayer setDoubleSided:NO];
  
  [theBack setHidden:NO];
  CALayer *backLayer = [[CALayer alloc] init];
  [backLayer setFrame:[theBack bounds]];
  [backLayer setContents:(id)[self CGImageWithView:theBack]];
  [backLayer setTransform:CATransform3DMakeRotation(M_PI, 0, 1, 0)];
  [theBack setHidden:YES];
  
  CALayer *layer = [[CALayer alloc] init];
  [layer setFrame:[theFront frame]];
  [layer addSublayer:backLayer];
  [layer addSublayer:frontLayer];
  [layer setDelegate:self];
  [layer setActions:[self createActions]];
  return layer;
}

- (CGImageRef)CGImageWithView:(NSView *)aView {
  NSData *data = [aView dataWithPDFInsideRect:[aView bounds]];
  NSImage *image = [[NSImage alloc] initWithData:data];  
  CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[image TIFFRepresentation], NULL);
  return CGImageSourceCreateImageAtIndex(source, 0, NULL);
}

- (NSDictionary *)createActions {
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:flipKey];
  [animation setDelegate:self];
  [animation setDuration:0.5];
  [animation setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
  [animation setToValue:[NSValue valueWithCATransform3D:[self createFlipTransform]]];
  return [NSDictionary dictionaryWithObject:animation forKey:flipKey];
}

@end