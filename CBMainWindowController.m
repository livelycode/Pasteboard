#import "Cloudboard.h"

@implementation CBMainWindowController

- (id)init
{
    self = [super init];
    if (self != nil)
    {
    /*    NSString *URLType = [settings objectForKey:@"URLType"];
        NSString *textType = [settings objectForKey:@"textType"];
        types = [NSArray arrayWithObjects:URLType, textType, nil];*/
        
        mainWindow = nil;
        
        mainLayer = [CALayer layer];
        [mainLayer setBackgroundColor:CGColorCreateGenericGray(0, 1)];
        
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

@end

@implementation CBMainWindowController(Delegation)

- (void)hotKeyPressed:(CBHotKey *)hotKey
{
    if (mainLayerHidden == NO)
    {
        [mainLayer setActions:[NSDictionary dictionaryWithObject:fadeOut
                                                          forKey:@"opacity"]];
        [mainLayer setOpacity:0];
    }
    else
    {
        [mainWindow makeKeyAndOrderFront:self];
        [mainLayer setActions:[NSDictionary dictionaryWithObject:fadeIn
                                                          forKey:@"opacity"]];
        [mainLayer setOpacity:0.5];
    }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (mainLayerHidden == NO)
    {
        mainLayerHidden = YES;
        [mainWindow orderOut:self];
    }
    else
    {
        mainLayerHidden = NO;
    }
}

@end