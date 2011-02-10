#import "Cloudboard.h"

@implementation CBApplicationController

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        CBSettings *settings = [CBSettings sharedSettings];
        
        windowController = [[CBClipboardWindowController alloc] init];
        [windowController setFadeInDuration:[settings floatForKey:@"fadeOutDuration"]];
        
        hotKey = [[CBHotKey alloc] init];
        [hotKey setDelegate:windowController];
        
        clipboardObserver = [[CBPasteboardObserver alloc] init];
        [clipboardObserver setDelegate:windowController];
    }
    return self;
}

@end

@implementation CBApplicationController(Delegation)

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [windowController registerWindow];
    CGFloat time = [[CBSettings sharedSettings] floatForKey:@"timeInterval"];
    [clipboardObserver observeWithTimeInterval:time];
}

@end