#import "Cloudboard.h"

@implementation CBApplicationController

@end

@implementation CBApplicationController(Delegation)

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    CBSettings *settings = [CBSettings sharedSettings];
    
    CGRect mainFrame = [[NSScreen mainScreen] frame];
    CGFloat screenHeight = CGRectGetHeight(mainFrame);
    CGFloat screenWidth = CGRectGetWidth(mainFrame);
    CGFloat marginSide = 90;
    CGFloat marginBottom = 90;
    CGFloat clipboardHeight = screenHeight - (2 * marginBottom);
    CGFloat clipboardWidth = (screenWidth - (3 * marginSide)) / 2;
  
    CGRect leftFrame = CGRectMake(marginSide, marginBottom, clipboardWidth, clipboardHeight);
    CGRect rightFrame = CGRectMake(screenWidth - marginSide - clipboardWidth, marginBottom, clipboardWidth, clipboardHeight);
    windowController = [[CBMainWindowController alloc] init];
    leftClipboardController = [[CBClipboardController alloc] initWithFrame: leftFrame delegate: self];
    rightClipboardController = [[CBClipboardController alloc] initWithFrame: rightFrame delegate: self];
    
    hotKey = [[CBHotKeyObserver alloc] init];
    [hotKey setDelegate:windowController];
    
    CGFloat time = [[CBSettings sharedSettings] floatForKey:@"timeInterval"];
    pasteboardObserver = [[CBPasteboardObserver alloc] init];
    [pasteboardObserver setDelegate:leftClipboardController];
    [pasteboardObserver observeWithTimeInterval:time];
  
    //start Server in new thread
    NSThread *serverThread = [[NSThread alloc] initWithTarget:self selector: @selector(launchHTTPServer) object:nil];
    [serverThread start];
    [self startSyncing];
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
  SyncController *sync = [[SyncController alloc] init];
}

@end