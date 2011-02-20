#import "Cloudboard.h"

@implementation CBApplicationController

- (void)initClipboards {
  CGRect mainFrame = [[NSScreen mainScreen] frame];
  CGFloat screenHeight = CGRectGetHeight(mainFrame);
  CGFloat screenWidth = CGRectGetWidth(mainFrame);
  CGFloat marginSide = 90;
  CGFloat marginBottom = 90;
  CGFloat clipboardHeight = screenHeight - (2 * marginBottom);
  CGFloat clipboardWidth = (screenWidth - (3 * marginSide)) / 2;
  CGRect leftFrame = CGRectMake(marginSide, marginBottom, clipboardWidth, clipboardHeight);
  CGRect rightFrame = CGRectMake(screenWidth - marginSide - clipboardWidth, marginBottom, clipboardWidth, clipboardHeight);
  historyClipboardController = [[CBClipboardController alloc] initWithFrame: leftFrame viewController: self];
  syncingClipboardController = [[CBClipboardController alloc] initWithFrame: rightFrame viewController: self];
}

-(void) initPasteboardObserver {
  CGFloat time = [[CBSettings sharedSettings] floatForKey:@"timeInterval"];
  pasteboardObserver = [[CBPasteboardObserver alloc] init];
  pasteboardClasses = [NSArray arrayWithObject:[NSAttributedString class]];
  [pasteboardObserver setDelegate:self];
  [pasteboardObserver observeWithTimeInterval:time];
}

- (void)addSubview: (NSView*) subView {
  [[windowController rootView] addSubview:subView];
}

- (void)startSyncing {
  syncController = [[CBSyncController alloc] initWithClipboardController: historyClipboardController];
}

@end

@implementation CBApplicationController(Delegation)

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  CBSettings *settings = [CBSettings sharedSettings];
  windowController = [[CBMainWindowController alloc] init];
  [self initClipboards];
  hotKey = [[CBHotKeyObserver alloc] init];
  [hotKey setDelegate:windowController];
  [self initPasteboardObserver];
  [self startSyncing];
}

- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;
{
  NSArray *copiedItems = [aPasteboard readObjectsForClasses:pasteboardClasses options:nil];
  if([copiedItems count] > 0) {
    CBItem *item = [[CBItem alloc] initWithString: [copiedItems objectAtIndex:0]];
    [historyClipboardController insertItem:item atIndex:0];
  }
}

@end