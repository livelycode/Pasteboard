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
  CGRect frame = CGRectMake(screenWidth - marginSide - clipboardWidth, marginBottom, clipboardWidth, clipboardHeight);
  syncingClipboardController = [[CBClipboardController alloc] initWithFrame: frame viewController: self];
}

-(void) initPasteboardObserver {
  CGFloat time = [[CBSettings sharedSettings] floatForKey:@"timeInterval"];
  pasteboardObserver = [[CBPasteboardObserver alloc] init];
  pasteboardClasses = [[NSArray alloc] initWithObject:[NSAttributedString class]];
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
  windowController = [[CBMainWindowController alloc] init];
  [self initClipboards];
  hotKey = [[CBHotKeyObserver alloc] init];
  [hotKey setDelegate:windowController];
  [self initPasteboardObserver];
  [self startSyncing];
}

- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;
{
    NSArray *copiedItems = [aPasteboard readObjectsForClasses:pasteboardClasses
                                                      options:nil];
    if([copiedItems count] > 0)
    {
        id copiedItem = [copiedItems objectAtIndex:0];
        CBItem *item = [[CBItem alloc] initWithString:copiedItem];
        if ([historyClipboardController clipboardContainsItem:item] == NO)
        {
            [historyClipboardController insertItem:item
                                           atIndex:0]; 
        }
    }
}

@end