#import "Cloudboard.h"

@implementation CBClipboardView

@end

@implementation CBClipboardView(Private)

- (void)drawBackgroundWithPath:(NSBezierPath *)aPath {
  NSColor *startingColor = [NSColor woodColor];
  NSColor *endingColor = [startingColor saturateWithLevel:0.1];
  NSArray *colors = [NSArray arrayWithObjects:startingColor, endingColor, nil];
  NSGradient *gradient = [[NSGradient alloc] initWithColors:colors];
  [gradient drawInBezierPath:aPath angle:270];
  [[NSColor woodStructureColor] setFill];
  [aPath fill];
}

- (void)drawBorderWithPath:(NSBezierPath *)aPath {
  NSShadow* shadow = [[[NSShadow alloc] init] autorelease];
  [shadow setShadowOffset:NSZeroSize];
  [shadow setShadowBlurRadius:40];
  [shadow setShadowColor:[NSColor colorWithCalibratedWhite:0 alpha:0.8]];
  [shadow set];
  [[NSColor woodHighlightColor] setStroke];
  [aPath setLineWidth:2];
  [aPath stroke];
}

@end

@implementation CBClipboardView(Overridden)

- (void)drawRect:(NSRect)aRect {   
  NSRect contentFrame = [self bounds];
  NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:contentFrame xRadius:16 yRadius:16];
  [path addClip];
  [self drawBackgroundWithPath:path];
  [self drawBorderWithPath:path];
}

- (id)initWithFrame:(NSRect)aRect {
  self = [super initWithFrame:aRect];
  if (self != nil) {
    NSShadow *dropShadow = [[[NSShadow alloc] init] autorelease];
    [dropShadow setShadowOffset:NSMakeSize(0, -4)];
    [dropShadow setShadowBlurRadius:8];
    [dropShadow setShadowColor:[NSColor colorWithCalibratedWhite:0 alpha:0.8]];
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

- (CALayer *)snapshot {
  NSShadow *shadow = [[self shadow] retain];
  [self setShadow:nil];
  CALayer *layer = [super snapshot];
  [self setShadow:shadow];
  return layer;
}

@end