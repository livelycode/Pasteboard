#import "Cloudboard.h"

#define CORNER_RADIUS 16
#define LINE_WIDTH 8
#define STROKE_APLPHA 0.8

@implementation CBClipboardView(Private)

- (void)drawBackgroundWithPath:(NSBezierPath *)aPath {
  [[NSColor blackColor] setFill];
  [aPath fill];
  NSImage *backgroundImage = [NSImage imageNamed:@"background.png"];
  [[NSColor colorWithPatternImage:backgroundImage] setFill];
  [aPath fill];
}

- (void)drawStrokeWithPath:(NSBezierPath *)aPath {
  [[NSColor colorWithDeviceWhite:1 alpha:STROKE_APLPHA] setStroke];
  [aPath setLineWidth:LINE_WIDTH];
  [aPath stroke];
}

@end

@implementation CBClipboardView(Overridden)

- (void)drawRect:(NSRect)aRect {   
  CGRect contentFrame = [self bounds];
  NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:contentFrame xRadius:CORNER_RADIUS yRadius:CORNER_RADIUS];
  [path addClip];
  [self drawBackgroundWithPath:path];
  [self drawStrokeWithPath:path];
}

@end

@implementation CBClipboardView

@end

