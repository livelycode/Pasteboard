#import "Cloudboard.h"

@implementation CBApplicationController

@end

@implementation CBApplicationController(Delegation)

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    CBSettings *settings = [CBSettings sharedSettings];
    
    CGRect mainFrame = [[NSScreen mainScreen] frame];
    CGFloat padding = [settings floatForKey:@"clipboardPadding"];
    CGFloat height = mainFrame.size.height - (2 * padding);
    CGFloat width = (mainFrame.size.width - (3 * padding)) / 2;
    
    leftClipboard = [[CBClipboard alloc] initWithCapacity:12];
    
    NSUInteger rows = [settings integerForKey:@"rows"];
    NSUInteger columns = [settings integerForKey:@"columns"];
    CGRect leftFrame = CGRectMake(padding, padding, width, height);
    CGRect rightFrame = CGRectMake((width + (2 * padding)), padding, width, height);
    CBClipboardView *leftView = [[CBClipboardView alloc] initWithRows:rows
                                                              Columns:columns];
    [leftView setFrame:leftFrame];
    [leftView setCornerRadius:[settings floatForKey:@"cornerRadius"]];
    CBClipboardView *rightView = [[CBClipboardView alloc] init];
    
    [rightView setFrame:rightFrame];
    
    leftClipboardController = [[CBClipboardController alloc] initWithClipboard:leftClipboard
                                                                          view:leftView];
    
    windowController = [[CBMainWindowController alloc] init];
    [[windowController rootView] addSubview:leftView];
    [[windowController rootView] addSubview:rightView];
    
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