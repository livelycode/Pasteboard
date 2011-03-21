#import "Cloudboard.h"

static CALayer *rootLayer;

@implementation CBMainWindowController

+ (void)addSublayerToRootLayer:(CALayer *)aLayer {
  [rootLayer addSublayer:aLayer];
}

- (void)toggleVisibility {
  if ([mainWindow isVisible]) {
    [mainWindow orderOut:self];
  } else {
    [mainWindow makeKeyAndOrderFront:self];
  }
}

- (id)initWithFrontView:(NSView *)theFront backView:(NSView *)theBack {
  self = [super init];
  if (self != nil) {
    isFlipped = NO;
    flipKey = @"transform";
    CGRect mainFrame = [[NSScreen mainScreen] frame];
    CGRect clipboardFrame = [self createClipboardFrame];
    mainWindow = [self createWindowWithFrame:mainFrame];
    clipboardController = [[CBClipboardController alloc] initWithFrame:clipboardFrame windowController:self];
    syncController = [[CBSyncController alloc] initWithClipboardController:clipboardController];
    [clipboardController setSyncController:syncController];
    settingsController = [[CBSettingsController alloc] initWithFrame:clipboardFrame syncController:syncController];
    [settingsController setWindowController:self];
    frontView = [[clipboardController view] retain];
    backView = [[settingsController view] retain];
    [mainWindow setContentView:[self rootViewWithFrame:mainFrame front:frontView back:backView]];
  }
  return self;
}

- (void)showFront {
  flipLayer = [self layerWithFront:backView back:frontView];
  [CATransaction setDisableActions:YES];
  [CBMainWindowController addSublayerToRootLayer:flipLayer];
  [CATransaction setDisableActions:NO];
  [backView setHidden:YES];
  [flipLayer setTransform:[self createFlipTransform]];
}

- (void)showBack {
  flipLayer = [self layerWithFront:frontView back:backView];
  [CATransaction setDisableActions:YES];
  [CBMainWindowController addSublayerToRootLayer:flipLayer];
  [CATransaction setDisableActions:NO];
  [frontView setHidden:YES];
  [flipLayer setTransform:[self createFlipTransform]];
}

- (CBClipboardController *)clipboardController {
  return clipboardController;
}

- (void)dealloc {
  [mainWindow release];
  [clipboardController release];
  [settingsController release];
  [syncController release];
  [frontView release];
  [backView release];
  [flipLayer release];
  [flipKey release];
  [super dealloc];
}

@end

@implementation CBMainWindowController(Delegation)

- (void)hotKeyPressed:(CBHotKeyObserver *)hotKey {
  [self toggleVisibility];
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

- (CBWindowView *)rootViewWithFrame:(CGRect)aRect front:(NSView *)theFront back:(NSView *)theBack {
  NSView *animationView = [[[NSView alloc] initWithFrame:aRect] autorelease];
  rootLayer = [[CALayer alloc] init];
  [animationView setLayer:rootLayer];
  [animationView setWantsLayer:YES];
  CBWindowView *view = [[[CBWindowView alloc] initWithFrame:aRect] autorelease];
  [view setWantsLayer:YES];
  [view setSubviews:[NSArray arrayWithObjects:theBack, theFront, animationView, nil]];
  return view;
}

- (CBWindow *)createWindowWithFrame:(CGRect)aRect {
  CBWindow *window = [[CBWindow alloc] initWithContentRect:aRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
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

- (CALayer *)layerWithFront:(id)theFront back:(id)theBack {
  CALayer *frontLayer = [theFront snapshot];
  [frontLayer setFrame:[theFront bounds]];
  [frontLayer setDoubleSided:NO];
  
  [theBack setHidden:NO];
  CALayer *backLayer = [theBack snapshot]; 
  [backLayer setFrame:[theBack bounds]];
  [backLayer setTransform:CATransform3DMakeRotation(M_PI, 0, 1, 0)];
  [theBack setHidden:YES];
  
  CALayer *layer = [CALayer layer];
  [layer setFrame:[theFront frame]];
  [layer addSublayer:backLayer];
  [layer addSublayer:frontLayer];
  [layer setDelegate:self];
  [layer setActions:[self actions]];
  return layer;
}

- (NSDictionary *)actions {
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:flipKey];
  [animation setDelegate:self];
  [animation setDuration:0.5];
  [animation setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
  [animation setToValue:[NSValue valueWithCATransform3D:[self createFlipTransform]]];
  return [NSDictionary dictionaryWithObject:animation forKey:flipKey];
}

@end