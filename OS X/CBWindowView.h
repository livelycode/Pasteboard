#import "Cocoa.h"

@interface CBWindowView : NSView
{
    @private
}

- (id)initWithFrame:(NSRect)aFrame;

- (void)mouseDown:(NSEvent *)theEvent;

- (void)drawRect:(NSRect)aRect;

@end