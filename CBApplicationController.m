#import "Cloudboard.h"

@implementation CBApplicationController

@end

@implementation CBApplicationController(Delegation)

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    CBSettings *settings = [CBSettings sharedSettings];
    
    CBClipboard *clipboard = [[CBClipboard alloc] initWithCapacity:12];
    
    CALayer *clipboardLayer = [[CALayer alloc] init];
    CGColorRef color = CGColorCreateGenericGray(0, [settings floatForKey:@"opacity"]);
    CGRect mainFrame = CGRectMake(0, 0, 512, 512);
    [clipboardLayer setFrame:mainFrame];
    [clipboardLayer setCornerRadius:[settings floatForKey:@"cornerRadius"]];
    [clipboardLayer setOpacity:[settings floatForKey:@"opacity"]];
    [clipboardLayer setBackgroundColor:color];
    CFRelease(color);
    
    clipboardController = [[CBClipboardController alloc] initWithClipboard:clipboard
                                                                     layer:clipboardLayer];
    [clipboardController setTypes:[settings objectForKey:@"URITypes"]];
    
    hotKey = [[CBHotKey alloc] init];
    
    pasteboardObserver = [[CBPasteboardObserver alloc] init];
    [pasteboardObserver setDelegate:clipboardController];
    
    NSWindow *mainWindow = [[NSWindow alloc] initWithContentRect:CGRectMake(0, 0, 512, 512)
                                                       styleMask:NSBorderlessWindowMask
                                                         backing:NSBackingStoreBuffered
                                                           defer:NO];
    [mainWindow setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
    [mainWindow setLevel:NSScreenSaverWindowLevel];
    [mainWindow setOpaque:NO];
    [mainWindow setBackgroundColor:[NSColor clearColor]];
    [mainWindow center];
    
    windowController = [[CBMainWindowController alloc] initWithWindow:mainWindow];
    [[windowController rootLayer] addSublayer:clipboardLayer];
    [hotKey setDelegate:windowController];
    
    CGFloat time = [[CBSettings sharedSettings] floatForKey:@"timeInterval"];
    [pasteboardObserver observeWithTimeInterval:time];
}

@end