#import "Cloudboard.h"

#define CORNER_RADIUS 16
#define BORDER_WIDTH 2
#define BORDER_ALPHA 0.6
#define INNER_SHADOW_BLUR 40
#define INNER_SHADOW_ALPHA 0.8
#define DROP_SHADOW_OFFSET -4
#define DROP_SHADOW_BLUR 8
#define DROP_SHADOW_ALPHA 0.8

@implementation CBClipboardView

@end

@implementation CBClipboardView(Private)

- (void)drawBackgroundWithPath:(NSBezierPath *)aPath {
  [[NSColor blackColor] setFill];
  [aPath fill];
  NSImage *backgroundImage = [NSImage imageNamed:@"background.png"];
  [[NSColor colorWithPatternImage:backgroundImage] setFill];
  [aPath fill];
}

- (void)drawBorderWithPath:(NSBezierPath *)aPath {
  NSShadow* shadow = [[[NSShadow alloc] init] autorelease];
  [shadow setShadowOffset:NSZeroSize];
  [shadow setShadowBlurRadius:INNER_SHADOW_BLUR];
  [shadow setShadowColor:[NSColor colorWithCalibratedWhite:0 alpha:INNER_SHADOW_ALPHA]];
  [shadow set];
  [[[NSColor whiteColor] colorWithAlphaComponent:BORDER_ALPHA] setStroke];
  [aPath setLineWidth:BORDER_WIDTH];
  [aPath stroke];
}

@end

@implementation CBClipboardView(Overridden)

- (void)drawRect:(NSRect)aRect {   
  NSRect contentFrame = [self bounds];
  NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:contentFrame xRadius:CORNER_RADIUS yRadius:CORNER_RADIUS];
  [path addClip];
  [self drawBackgroundWithPath:path];
  [self drawBorderWithPath:path];
}

- (id)initWithFrame:(NSRect)aRect {
  self = [super initWithFrame:aRect];
  if (self != nil) {
    NSShadow *dropShadow = [[NSShadow alloc] init];
    [dropShadow setShadowOffset:NSMakeSize(0, DROP_SHADOW_OFFSET)];
    [dropShadow setShadowBlurRadius:DROP_SHADOW_BLUR];
    [dropShadow setShadowColor:[NSColor colorWithCalibratedWhite:0 alpha:DROP_SHADOW_ALPHA]];
    [self setShadow:dropShadow];
  }
  return self;
}

- (void)mouseDown:(NSEvent *)theEvent {}

@end