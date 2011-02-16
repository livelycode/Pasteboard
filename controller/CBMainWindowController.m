#import "Cloudboard.h"

@implementation CBMainWindowController

- (id)init;
{
    self = [super init];
    if (self != nil)
    {
        CGRect mainFrame = [[NSScreen mainScreen] frame];
        
        mainWindow = [[NSWindow alloc] initWithContentRect:mainFrame
                                                 styleMask:NSBorderlessWindowMask
                                                   backing:NSBackingStoreBuffered
                                                     defer:NO];
        [mainWindow setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
        [mainWindow setLevel:NSScreenSaverWindowLevel];
        [mainWindow setOpaque:NO];
        [mainWindow setBackgroundColor:[NSColor clearColor]];
        
        rootView = [mainWindow contentView];
        [rootView setWantsLayer:YES];
        
        fadeIn = [CABasicAnimation animationWithKeyPath:@"alphaValue"];
        [fadeIn setDelegate:self];
        fadeOut = [CABasicAnimation animationWithKeyPath:@"alphaValue"];
        [fadeOut setDelegate:self];
        
        mainLayerHidden = YES;
    }
    return self;
}

- (void)setFadeInDuration:(NSTimeInterval)time
{
    [fadeIn setDuration:time];
}

- (void)setFadeOutDuration:(NSTimeInterval)time
{
    [fadeOut setDuration:time];
}

- (NSView *)rootView;
{
    return rootView;
}

@end

@implementation CBMainWindowController(Delegation)

- (void)hotKeyPressed:(CBHotKeyObserver *)hotKey
{
    if (mainLayerHidden == NO)
    {
        [rootView setAlphaValue:0];
        [mainWindow orderOut:self];
        mainLayerHidden = YES;
    }
    else
    {
        [mainWindow makeKeyAndOrderFront:self];
        [rootView setAlphaValue:1];
        mainLayerHidden = NO;
    }
}

@end