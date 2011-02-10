#import "Cloudboard.h"

@implementation CBWindowController

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        CBSettings *settings = [CBSettings sharedSettings];
        
        clipboard = [[CBClipboard alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [clipboard setCornerRadius:[settings floatForKey:@"cornerRadius"]];
        [clipboard setOpacity:[settings floatForKey:@"opacity"]];
        
        mainWindow = nil;
        
        mainLayer = [CALayer layer];
        [mainLayer setBackgroundColor:CGColorCreateGenericGray(0, 1)];
     //   [mainLayer addSublayer:[clipboard layer]];
        
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

@implementation CBWindowController(Delegation)

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    NSLog(@"foo");
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