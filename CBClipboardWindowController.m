#import "Cloudboard.h"

@implementation CBClipboardWindowController

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        CBSettings *settings = [CBSettings sharedSettings];
        
        clipboard = [[CBClipboard alloc] initWithCapacity:12];
        
        clipboardLayer = [[CBClipboardLayer alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [clipboardLayer setCornerRadius:[settings floatForKey:@"cornerRadius"]];
        [clipboardLayer setOpacity:[settings floatForKey:@"opacity"]];
        
        mainWindow = nil;
        
        mainLayer = [CALayer layer];
        [mainLayer setBackgroundColor:CGColorCreateGenericGray(0, 1)];
        [mainLayer addSublayer:[clipboardLayer layer]];
        
        fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [fadeIn setDelegate:self];
        fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [fadeOut setDelegate:self];
        
        mainLayerHidden = YES;
    }
    return self;
}

- (void)registerWindow
{
    if (mainWindow == nil)
    {
        mainWindow = [[NSWindow alloc] initWithContentRect:CGRectMake(100, 100, 200, 300)
                                                 styleMask:NSBorderlessWindowMask
                                                   backing:NSBackingStoreBuffered
                                                     defer:NO];
        [mainWindow setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
        [mainWindow setLevel:NSScreenSaverWindowLevel];
        [mainWindow setOpaque:NO];
        [mainWindow setBackgroundColor:[NSColor clearColor]];
        
        NSView *mainView = [mainWindow contentView];
        [mainView setLayer:mainLayer];
        [mainView setWantsLayer:YES];
    }
}

- (void)setFadeInDuration:(CGFloat)aDuration
{
    [fadeIn setDuration:aDuration];
}

- (void)setFadeOutDuration:(CGFloat)aDuration
{
    [fadeOut setDuration:aDuration];
}

@end

@implementation CBClipboardWindowController(Delegation)

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (mainLayerHidden == NO)
    {
        NSLog(@"1");
        mainLayerHidden = YES;
        [mainWindow orderOut:self];
    }
    else
    {
        NSLog(@"2");
        mainLayerHidden = NO;
    }
}

- (void)hotKeyPressed:(CBHotKey *)hotKey
{
    if (mainLayerHidden == NO)
    {
        NSLog(@"3");
        [mainLayer setActions:[NSDictionary dictionaryWithObject:fadeOut
                                                          forKey:@"opacity"]];
        [mainLayer setOpacity:0];
    }
    else
    {
        NSLog(@"4");
        [mainWindow makeKeyAndOrderFront:self];
        [mainLayer setActions:[NSDictionary dictionaryWithObject:fadeIn
                                                          forKey:@"opacity"]];
        [mainLayer setOpacity:0.5];
    }
}

- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;
{
    for (NSPasteboardItem *item in [aPasteboard pasteboardItems])
    {
        CBItem *clipboardItem = [[CBItem alloc] initWithPasteboardItem:item];
        [clipboard insertItem:clipboardItem
                      AtIndex:0];
    }
    /*    Class NSStringClass = [NSString class];
     Class NSAttributedStringClass = [NSAttributedString class];
     Class NSURLClass = [NSURL class];
     Class NSImageClass = [NSImage class];
     Class NSColorClass = [NSColor class];
     
     NSArray *classes = [NSArray arrayWithObject:[NSURL class]];
     NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
     forKey:NSPasteboardURLReadingFileURLsOnlyKey];
     NSArray *fileURLs = [[NSPasteboard generalPasteboard] readObjectsForClasses:classes
     options:options];
     for (NSURL *URL in fileURLs)
     {
     CBClipboardItem *clipboardItem = [[CBClipboardItem alloc] initWithContentSize:CGSizeMake(128, 128)];
     [clipboardItem setFontSize:12];
     [clipboardItem setImageWithFile:URL];
     [clipboardItem setDescription:@"png"];
     [clipboard insertClipboardItem:clipboardItem
     atIndex:0];
     }*/
}

@end