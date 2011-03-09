#import "Cloudboard.h"

#define WINDOW_ALPHA 0.4

@implementation CBMainWindowController(Private)

- (CBWindowView *)createRootViewWihtFrame:(CGRect)aRect {
  CBWindowView *view = [[CBWindowView alloc] initWithFrame:aRect];
  [view setWantsLayer:YES];
  [view setColor:[NSColor colorWithCalibratedWhite:0 alpha:WINDOW_ALPHA]];
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

@end

@implementation CBMainWindowController(Delegation)

- (void)hotKeyPressed:(CBHotKeyObserver *)hotKey {
  if ([mainWindow isVisible]) {
    [mainWindow orderOut:self];
  } else {
    [mainWindow makeKeyAndOrderFront:self];
  }
}

@end

@implementation CBMainWindowController

- (id)initWithFrontView:(NSView *)theFront backView:(NSView *)theBack {
  self = [super init];
  if (self != nil) {
    CGRect mainFrame = [[NSScreen mainScreen] frame];
    CGRect clipboardFrame = [self createClipboardFrame];
    mainWindow = [self createWindowWithFrame:mainFrame];
    rootView = [self createRootViewWihtFrame:mainFrame];
    [mainWindow setContentView:rootView];
    clipboardController = [[CBClipboardController alloc] initWithFrame:clipboardFrame];
    [clipboardController setWindowController:self];
    syncController = [[CBSyncController alloc] initWithClipboardController:clipboardController];
    [clipboardController setSyncController:syncController];
    settingsController = [[CBSettingsController alloc] initWithFrame:clipboardFrame];
    [settingsController setSyncController:syncController];
    [settingsController setWindowController:self];
    [rootView addSubview:[clipboardController view]];
    front = [clipboardController view];
    back = [settingsController view];
  }
  return self;
}

- (void)showFront {
  [back removeFromSuperview];
  [rootView addSubview:front];
  NSLog(@"foo");
}

- (void)showBack {
  [front removeFromSuperview];
  [rootView addSubview:back];
}

- (CBClipboardController *)clipboardController {
  return clipboardController;
}

@end

