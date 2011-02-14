#import "Cloudboard.h"

@implementation CBApplicationController

@end

@implementation CBApplicationController(Delegation)

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    CBSettings *settings = [CBSettings sharedSettings];
    
    CGRect mainFrame = [[NSScreen mainScreen] frame];
    mainFrame.size.height = mainFrame.size.height - [[NSStatusBar systemStatusBar] thickness];
    CGFloat padding = [settings floatForKey:@"clipboardPadding"];
    CGFloat height = mainFrame.size.height - (2 * padding);
    CGFloat width = (mainFrame.size.width - (3 * padding)) / 2;
    
    CBClipboard *clipboard = [[CBClipboard alloc] initWithCapacity:12];
    
    CGColorRef color = CGColorCreateGenericGray(0, [settings floatForKey:@"opacity"]);
    CALayer *leftLayer = [[CALayer alloc] init];
    CGRect leftFrame = CGRectMake(padding, padding, width, height);
    [leftLayer setFrame:leftFrame];
    [leftLayer setCornerRadius:[settings floatForKey:@"cornerRadius"]];
    [leftLayer setOpacity:[settings floatForKey:@"opacity"]];
    [leftLayer setBackgroundColor:color];
    CALayer *rightLayer = [[CALayer alloc] init];
    CGRect rightFrame = CGRectMake((2 * padding) + width, padding, width, height);
    [rightLayer setFrame:rightFrame];
    [rightLayer setCornerRadius:[settings floatForKey:@"cornerRadius"]];
    [rightLayer setOpacity:[settings floatForKey:@"opacity"]];
    [rightLayer setBackgroundColor:color];
    CFRelease(color);
    
    clipboardController = [[CBClipboardController alloc] initWithClipboard:clipboard
                                                                     layer:leftLayer];
    [clipboardController setTypes:[settings objectForKey:@"URITypes"]];
    
    hotKey = [[CBHotKey alloc] init];
    
    pasteboardObserver = [[CBPasteboardObserver alloc] init];
    [pasteboardObserver setDelegate:clipboardController];
    
    NSWindow *mainWindow = [[NSWindow alloc] initWithContentRect:mainFrame
                                                       styleMask:NSBorderlessWindowMask
                                                         backing:NSBackingStoreBuffered
                                                           defer:NO];
    [mainWindow setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
    [mainWindow setLevel:NSScreenSaverWindowLevel];
    [mainWindow setOpaque:NO];
    [mainWindow setBackgroundColor:[NSColor clearColor]];
    
    windowController = [[CBMainWindowController alloc] initWithWindow:mainWindow];
    [[windowController rootLayer] addSublayer:leftLayer];
    [[windowController rootLayer] addSublayer:rightLayer];
    [hotKey setDelegate:windowController];
    
    CGFloat time = [[CBSettings sharedSettings] floatForKey:@"timeInterval"];
    [pasteboardObserver observeWithTimeInterval:time];
    [self launchHTTPServer];
}

- (void)launchHTTPServer {
/*  HTTPServer *server = [[HTTPServer alloc] init];
  [server setType:@"_http._tcp."];
  [server setName:@"Cocoa HTTP Server"];
  [server setPort: 8090];
  connectionDelegate = [[HTTPConnectionDelegate alloc] init];
  [server setDelegate: connectionDelegate];
  
  NSError *startError = nil;
  if (![server start:&startError] ) {
    NSLog(@"Error starting server: %@", startError);
  } else {
    NSLog(@"Starting server on port %d", [server port]);
  }*/
  HTTPServer *server = [[HTTPServer alloc] init];
  [server setType:@"_http._tcp."];
  [server setName:@"Cocoa HTTP Server"];
  [server setDocumentRoot:[NSURL fileURLWithPath:@"/"]];
  
  NSError *startError = nil;
  if (![server start:&startError] ) {
    NSLog(@"Error starting server: %@", startError);
  } else {
    NSLog(@"Starting server on port %d", [server port]);
  }

}

@end