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
  NSColor *startingColor = [NSColor colorWithCalibratedRed:(172.0/255) green:(114.0/255) blue:(44.0/255) alpha:1];
  NSColor *endingColor = [NSColor colorWithCalibratedRed:(129.0/255) green:(67.0/255) blue:(21.0/255) alpha:1];
  NSArray *colors = [NSArray arrayWithObjects:startingColor, endingColor, nil];
  NSGradient *gradient = [[NSGradient alloc] initWithColors:colors];
  [gradient drawInBezierPath:aPath angle:270];
  NSImage *structure = [NSImage imageNamed:@"Structure.png"];
  [[NSColor colorWithPatternImage:structure] setFill];
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
    NSShadow *dropShadow = [[[NSShadow alloc] init] autorelease];
    [dropShadow setShadowOffset:NSMakeSize(0, DROP_SHADOW_OFFSET)];
    [dropShadow setShadowBlurRadius:DROP_SHADOW_BLUR];
    [dropShadow setShadowColor:[NSColor colorWithCalibratedWhite:0 alpha:DROP_SHADOW_ALPHA]];
    [self setShadow:dropShadow];
  }
  return self;
}

- (void)mouseDown:(NSEvent *)theEvent {}

- (BOOL)performKeyEquivalent:(NSEvent *)event {
  if (([event modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask) {
    if ([[event charactersIgnoringModifiers] isEqualToString:@"v"]) {
      [(CBApplicationController*)[[NSApplication sharedApplication] delegate] pasteItem];
      return YES;
    }
  }
  return NO;    
}

@end