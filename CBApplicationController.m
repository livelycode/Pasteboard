#import "Cloudboard.h"

@implementation CBApplicationController

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        CBSettings *settings = [CBSettings sharedSettings];
        
        CBClipboard *clipboard = [[CBClipboard alloc] initWithCapacity:12];
        
        CALayer *clipboardLayer = [[CALayer alloc] init];
        CGColorRef color = CGColorCreateGenericGray(0, [settings floatForKey:@"opacity"]);
        CGRect mainFrame = CGRectMake(0, 0, 200, 300);
        [clipboardLayer setFrame:mainFrame];
        [clipboardLayer setCornerRadius:[settings floatForKey:@"cornerRadius"]];
        [clipboardLayer setOpacity:[settings floatForKey:@"opacity"]];
        [clipboardLayer setBackgroundColor:color];
        CFRelease(color);
        
        clipboardController = [[CBClipboardController alloc] initWithClipboard:clipboard
                                                                         layer:clipboardLayer];
        [clipboardController setTypes:[settings objectForKey:@"URITypes"]];
        
        windowController = [[CBMainWindowController alloc] init];
        
        hotKey = [[CBHotKey alloc] init];
        [hotKey setDelegate:windowController];
        
        pasteboardObserver = [[CBPasteboardObserver alloc] init];
        [pasteboardObserver setDelegate:clipboardController];
    }
    return self;
}

@end

@implementation CBApplicationController(Delegation)

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [windowController registerWindow];
    CGFloat time = [[CBSettings sharedSettings] floatForKey:@"timeInterval"];
    [pasteboardObserver observeWithTimeInterval:time];
}

@end