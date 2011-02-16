#import "Cloudboard.h"

@implementation CBView

- (void)setDelegate:(id <CBViewDelegate>)anObject
{
    delegate = anObject;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [delegate view:self didReceiveMouseDown:theEvent];
}

- (void)mouseUp:(NSEvent *)theEvent
{
    [delegate view:self didReceiveMouseUp:theEvent];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    [delegate view:self didReceiveMouseDragged:theEvent];
}

@end