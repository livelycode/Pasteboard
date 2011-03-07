#import "Cloudboard.h"

#define CORNER_RADIUS 16
#define LINE_WIDTH 2

@implementation CBClipboardView(Private)

- (void)drawBackgroundWithPath:(NSBezierPath *)aPath {
  [[NSColor blackColor] setFill];
  [aPath fill];
  NSImage *backgroundImage = [NSImage imageNamed:@"background.png"];
  [[NSColor colorWithPatternImage:backgroundImage] setFill];
  [aPath fill];
}

- (void)drawBorderWithPath:(NSBezierPath *)aPath {
  NSColor *shadowColor = [[NSColor blackColor] colorWithAlphaComponent:0.8];
  NSShadow* shadow = [[NSShadow alloc] init];
  [shadow setShadowOffset:NSZeroSize];
  [shadow setShadowBlurRadius:200];
  [shadow setShadowColor:shadowColor];
  [shadow set];
  [[[NSColor whiteColor] colorWithAlphaComponent:0.8] setStroke];
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
  [self drawBorderWithPath:path];
}

@end

@implementation CBClipboardView

@end

