#import "Cloudboard.h"

#define WINDOW_ALPHA 0.4

@implementation CBMainWindowController

- (id)init;
{
    self = [super init];
    if (self != nil)
    {
        CGRect mainFrame = [[NSScreen mainScreen] frame];
        
        rootView = [[CBWindowView alloc] initWithFrame:mainFrame];
        [rootView setWantsLayer:YES];
        [rootView setColor:[NSColor colorWithCalibratedWhite:0
                                                       alpha:WINDOW_ALPHA]];
        
        mainWindow = [[NSWindow alloc] initWithContentRect:mainFrame
                                                 styleMask:NSBorderlessWindowMask
                                                   backing:NSBackingStoreBuffered
                                                     defer:NO];
        [mainWindow setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
        [mainWindow setLevel:NSStatusWindowLevel];
        [mainWindow setOpaque:NO];
        [mainWindow setBackgroundColor:[NSColor clearColor]];
        
        [mainWindow setContentView:rootView];
        
    }
    return self;
}

- (NSView *)rootView;
{
    return rootView;
}

@end

@implementation CBMainWindowController(Delegation)

- (void)hotKeyPressed:(CBHotKeyObserver *)hotKey
{
    if ([mainWindow isVisible])
    {
        [mainWindow orderOut:self];
    }
    else
    {
        [mainWindow makeKeyAndOrderFront:self];
    }
}

@end