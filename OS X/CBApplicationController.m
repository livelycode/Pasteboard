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
  pasteboardObserver = [[CBPasteboardObserver alloc] init];
  pasteboardClasses = [NSArray arrayWithObject:[NSAttributedString class]];
  [pasteboardObserver setDelegate:self];
  [pasteboardObserver observeWithTimeInterval:0.1];
}

- (void)addSubview: (NSView*) subView {
  [[windowController rootView] addSubview:subView];
}

- (void)startSyncing {
  syncController = [[CBSyncController alloc] initWithClipboardController: syncingClipboardController];
  [syncingClipboardController addChangeListener: syncController];
}

- (void)openPreferences {
  if (preferencesController == nil) {
    preferencesController = [[CBPreferencesController alloc] initWithWindowNibName:@"preferences"];
  }
  [preferencesController showWindow:nil];
  [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
  [[preferencesController window] makeKeyAndOrderFront:nil];
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
  [self openPreferences];
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