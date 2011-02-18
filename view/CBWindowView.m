#import "Cloudboard.h"

@implementation CBWindowView	

- (id)initWithFrame:(NSRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self != nil)
    {
        color = [NSColor whiteColor];
    }
    return self;
}

- (void)drawRect:(NSRect)aRect
{
    [color set];
    CGRect frame = [self bounds];
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:frame];
    [path fill];
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [[self window] orderOut:self];
}

- (void)setColor:(NSColor *)aColor
{
    color = aColor;
}

@end