#import "Cloudboard.h"

@implementation CBApplicationController

- (void)initClipboard {
  CGRect mainFrame = [[NSScreen mainScreen] frame];
  CGFloat screenHeight = CGRectGetHeight(mainFrame);
  CGFloat screenWidth = CGRectGetWidth(mainFrame);
  CGFloat marginSide = 40;
  CGFloat marginBottom = 50;
  CGFloat clipboardHeight = screenHeight - (2 * marginBottom);
  CGFloat clipboardWidth = (screenWidth - (3 * marginSide)) / 2;
  CGRect leftFrame = CGRectMake((screenWidth-clipboardWidth)/2, marginBottom, clipboardWidth, clipboardHeight);
  clipboardController = [[CBClipboardController alloc] initWithFrame: leftFrame viewController: self];
}

-(void) initPasteboardObserver {
  pasteboardObserver = [[CBPasteboardObserver alloc] init];
  pasteboardClasses = [NSArray arrayWithObject:[NSAttributedString class]];
  [pasteboardObserver setDelegate:self];
  [pasteboardObserver observeWithTimeInterval:0.1];
}

- (void)addSubview: (NSView*) subView {
  [[windowController rootView] addSubview:subView];
}

- (void)startSyncing {
  syncController = [[CBSyncController alloc] initWithClipboardController: clipboardController];
  [syncController addDelegate:self];
}

- (void)openPreferences {
  if (preferencesController == nil) {
    preferencesController = [[CBPreferencesController alloc] initWithAppController: self];
  }
  [preferencesController showWindow:nil];
  [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
  [[preferencesController window] makeKeyAndOrderFront:nil];
}

- (CBSyncController*)syncController {
  return syncController;
}

@end

@implementation CBApplicationController(Delegation)

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  windowController = [[CBMainWindowController alloc] init];
  [self initClipboard];
  hotKey = [[CBHotKeyObserver alloc] init];
  [hotKey setDelegate:windowController];
  [self initPasteboardObserver];
  [self startSyncing];
  [self openPreferences];
}

- (void)systemPasteboardDidChange {
  CBItem* newItem = [self currentPasteboardItem];
  if(newItem) {
    if ([clipboardController clipboardContainsItem:newItem] == NO) {
      [clipboardController addItem:newItem syncing:YES];
    }
  }
}

- (CBItem*)currentPasteboardItem {
  CBItem *item;
  NSArray *items = [[NSPasteboard generalPasteboard] readObjectsForClasses:pasteboardClasses options:nil];
  if([items count] > 0) {
    id copiedItem = [items objectAtIndex:0];
    item = [[CBItem alloc] initWithString:copiedItem];
  }
  return item;
}

//CBSyncControllerDelegate
- (void)clientRequiresUserConfirmation:(NSString*)clientName {
  NSLog(@"client asks for registration: %@", clientName);
}

@end