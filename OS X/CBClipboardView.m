#import "Cloudboard.h"

#define CORNER_RADIUS 12

@implementation CBClipboardView(Private)

- (void)drawBackgroundWithPath:(NSBezierPath *)aPath {
  NSImage *image = [NSImage imageNamed:@"background.png"];
  NSColor *color = [NSColor colorWithPatternImage:image];
  [color setFill];
  [aPath fill];
}

@end

@implementation CBClipboardView(Overridden)

- (void)drawRect:(NSRect)aRect {   
  CGRect contentFrame = [self bounds];
  NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:contentFrame xRadius:CORNER_RADIUS yRadius:CORNER_RADIUS];
  [self drawBackgroundWithPath:path];
}

@end

@implementation CBClipboardView

@end

