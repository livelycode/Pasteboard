#import "Cloudboard.h"

@implementation CBMainWindowController

- (id)initWithWindow:(NSWindow *)aWindow;
{
    self = [super init];
    if (self != nil)
    {
        mainWindow = aWindow;
        
        rootLayer = [CALayer layer];
        [rootLayer setDelegate:self];
        [rootLayer setOpacity:0];
        
        CGSize windowSize = [mainWindow frame].size;
        CGRect clipboardFrame = CGRectMake(0, 0, windowSize.width, windowSize.height);
        CBView *clipboardView = [[CBView alloc] initWithFrame:clipboardFrame];
        [clipboardView setLayer:rootLayer];
        [clipboardView setWantsLayer:YES];
        
        [[mainWindow contentView] addSubview:clipboardView];
        
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
        [rootLayer setOpacity:0];
    }
    else
    {
        [mainWindow makeKeyAndOrderFront:self];
        [rootLayer setOpacity:1];
    }
}

- (void)animationDidStop:(CAAnimation *)theAnimation
                finished:(BOOL)flag
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

- (id <CAAction>)actionForLayer:(CALayer *)layer
                         forKey:(NSString *)key
{
    CABasicAnimation *fade = nil;
    if ([key isEqualToString:@"opacity"])
    {
        if (mainLayerHidden == NO)
        {
            fade = fadeOut;
        }
        else
        {
            fade = fadeIn;
        }  
    }
    return fade;
}

@end