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
    
    leftClipboard = [[CBClipboard alloc] initWithCapacity:12];
    
    CGColorRef color = CGColorCreateGenericGray(0, [settings floatForKey:@"opacity"]);
    NSUInteger rows = [settings integerForKey:@"rows"];
    NSUInteger columns = [settings integerForKey:@"columns"];
    CBClipboardLayer *leftLayer = [[CBClipboardLayer alloc] initWithRows:rows
                                                        Columns:columns];
    CGRect leftFrame = CGRectMake(0, 0, width, height);
    [leftLayer setFrame:leftFrame];
    [leftLayer setCornerRadius:[settings floatForKey:@"cornerRadius"]];
    [leftLayer setBackgroundColor:color];
    CBClipboardLayer *rightLayer = [[CBClipboardLayer alloc] init];
    CGRect rightFrame = CGRectMake((width + padding), 0, width, height);
    [rightLayer setFrame:rightFrame];
    [rightLayer setCornerRadius:[settings floatForKey:@"cornerRadius"]];
    [rightLayer setBackgroundColor:color];
    CFRelease(color);
    
    leftClipboardController = [[CBClipboardController alloc] initWithClipboard:leftClipboard
                                                                         layer:leftLayer];
    [leftClipboardController setTypes:[settings objectForKey:@"URITypes"]];
    
    NSWindow *mainWindow = [[NSWindow alloc] initWithContentRect:CGRectMake(padding, padding, ((2 * width) + padding), height)
                                                       styleMask:NSBorderlessWindowMask
                                                         backing:NSBackingStoreBuffered
                                                           defer:NO];
    [mainWindow setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
    [mainWindow setLevel:NSScreenSaverWindowLevel];
    [mainWindow setOpaque:NO];
    [mainWindow setBackgroundColor:[NSColor clearColor]];
    
    windowController = [[CBMainWindowController alloc] initWithWindow:mainWindow];
    [windowController setFadeInDuration:[settings floatForKey:@"fadeInDuration"]];
    [windowController setFadeOutDuration:[settings floatForKey:@"fadeOutDuration"]];
    [[windowController rootLayer] addSublayer:leftLayer];
    [[windowController rootLayer] addSublayer:rightLayer];
    
    hotKey = [[CBHotKey alloc] init];
    [hotKey setDelegate:windowController];
    
    CGFloat time = [[CBSettings sharedSettings] floatForKey:@"timeInterval"];
    pasteboardObserver = [[CBPasteboardObserver alloc] init];
    [pasteboardObserver setDelegate:self];
    [pasteboardObserver observeWithTimeInterval:time];
    [self launchHTTPServer];
}

- (void)launchHTTPServer {
  HTTPServer *server = [[HTTPServer alloc] init];
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
  }
  [[NSRunLoop currentRunLoop] run];
}

- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;
{
    for (NSPasteboardItem *item in [aPasteboard pasteboardItems])
    {
        [leftClipboard insertItem:item
                      AtIndex:0];
    }
    [leftClipboardController updateItemLayers];
}

@end