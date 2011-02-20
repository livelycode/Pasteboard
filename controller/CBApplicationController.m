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

- (void)launchHTTPServer {
  HTTPServer *server = [[HTTPServer alloc] init];
  [server setType:@"_http._tcp."];
  [server setName:@"Cloudboard Server"];
  [server setPort: 8090];
  connectionDelegate = [[HTTPConnectionDelegate alloc] init];
  [server setDelegate: connectionDelegate];
  
  NSError *startError = nil;
  if (![server start:&startError] ) {
    NSLog(@"Error starting server: %@", startError);
  } else {
    NSLog(@"Starting server on port %d", [server port]);
  }
  [[NSRunLoop currentRunLoop] run];
}

- (void)startSyncing {
  CBSyncController *sync = [[CBSyncController alloc] init];
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
  
    //start Server in new thread
    NSThread *serverThread = [[NSThread alloc] initWithTarget:self selector: @selector(launchHTTPServer) object:nil];
    [serverThread start];
    [self startSyncing];
}

- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;
{
  NSArray *copiedItems = [aPasteboard readObjectsForClasses:pasteboardClasses options:nil];
  NSMutableArray *cbItems = [NSMutableArray arrayWithCapacity: [copiedItems count]];
  for (NSAttributedString *string in copiedItems)
  {
    CBItem *item = [[CBItem alloc] initWithString:string];
    [cbItems addObject:item];
  }
  [historyClipboardController insertItems:cbItems atIndex:0];
}

@end