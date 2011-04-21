#import "Cloudboard.h"

@implementation CBWindowView	

- (id)initWithFrame:(NSRect)aFrame {
    self = [super initWithFrame:aFrame];
    if (self != nil) {
      hideable = YES;
    }
    return self;
}

- (void)setHideable:(BOOL)isHideable {
  hideable = isHideable;
}

- (void)drawRect:(NSRect)aRect {
  NSColor* color = [NSColor colorWithCalibratedWhite:0 alpha:0.4];
  [color set];
  CGRect frame = [self bounds];
  NSBezierPath *path = [NSBezierPath bezierPathWithRect:frame];
  [path fill];
}

- (void)mouseDown:(NSEvent *)theEvent {
  if(hideable) {
    [[self window] orderOut:self];    
  }
}

@end