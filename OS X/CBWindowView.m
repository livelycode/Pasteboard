#import "Cloudboard.h"

@implementation CBWindowView	

- (id)initWithFrame:(NSRect)aFrame {
    self = [super initWithFrame:aFrame];
    if (self != nil) {

    }
    return self;
}

- (void)drawRect:(NSRect)aRect {
  NSColor* color = [NSColor colorWithCalibratedWhite:0 alpha:0.4];
  [color set];
  CGRect frame = [self bounds];
  NSBezierPath *path = [NSBezierPath bezierPathWithRect:frame];
  [path fill];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [[self window] orderOut:self];
}

@end