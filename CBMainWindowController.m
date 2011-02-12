#import "Cloudboard.h"

@implementation CBMainWindowController

- (id)initWithWindow:(NSWindow *)aWindow;
{
    self = [super init];
    if (self != nil)
    {
        mainWindow = aWindow;
        
        rootLayer = [CALayer layer];
        NSView *mainView = [mainWindow contentView];
        [mainView setLayer:rootLayer];
        [mainView setWantsLayer:YES];
        
        fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [fadeIn setDelegate:self];
        fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
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

- (CALayer *)rootLayer
{
    return rootLayer;
}

@end

@implementation CBMainWindowController(Delegation)

- (void)hotKeyPressed:(CBHotKey *)hotKey
{
    if (mainLayerHidden == NO)
    {
        [rootLayer setActions:[NSDictionary dictionaryWithObject:fadeOut
                                                          forKey:@"opacity"]];
        [rootLayer setOpacity:0];
    }
    else
    {
        [mainWindow makeKeyAndOrderFront:self];
        [rootLayer setActions:[NSDictionary dictionaryWithObject:fadeIn
                                                          forKey:@"opacity"]];
        [rootLayer setOpacity:0.5];
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