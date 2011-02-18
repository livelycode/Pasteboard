#import "Cocoa.h"

@interface CBWindowView : NSView
{
    @private
    NSColor *color;
}

- (id)initWithFrame:(NSRect)aFrame;

- (void)mouseDown:(NSEvent *)theEvent;

- (void)drawRect:(NSRect)aRect;

- (void)setColor:(NSColor *)aColor;

@end