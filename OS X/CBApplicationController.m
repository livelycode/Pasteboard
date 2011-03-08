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
  NSString* copyString = [[NSPasteboard generalPasteboard] stringForType:(NSString*)kUTTypeUTF8PlainText];
  return [[CBItem alloc] initWithString:[[NSAttributedString alloc] initWithString:copyString]];
}

//CBSyncControllerDelegate
- (void)clientRequiresUserConfirmation:(NSString*)clientName {
  NSLog(@"client asks for registration: %@", clientName);
}

@end