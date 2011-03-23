#import "Cloudboard.h"

@implementation CBPasteView(Private)

- (NSTrackingArea *)createTrackingAreaWithRect:(CGRect)aRect {
  NSTrackingAreaOptions options = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
  return [[NSTrackingArea alloc] initWithRect:aRect options:options owner:self userInfo:nil];
}

- (void)drawBorderWithRect:(CGRect)aRect {
  CGFloat width = CGRectGetWidth(aRect) / 52;
  CGRect highlightRect = CGRectOffset(aRect, 0, -1);
  NSBezierPath *highlightPath = [NSBezierPath bezierPathWithRoundedRect:highlightRect xRadius:16 yRadius:16];
  [highlightPath setLineWidth:width+2];
  [[NSColor woodLightColor] setStroke];
  [highlightPath stroke];
  
  NSBezierPath *borderPath = [NSBezierPath bezierPathWithRoundedRect:aRect xRadius:16 yRadius:16];
  [borderPath setLineWidth:width+2];
  [[NSColor woodBorderColor] setStroke];
  [borderPath stroke];
  
  NSBezierPath *embossPath = [NSBezierPath bezierPathWithRoundedRect:aRect xRadius:16 yRadius:16];
  [embossPath setLineWidth:width];
  [[NSColor woodDarkColor] setStroke];
  [embossPath stroke];
  [[NSColor woodStructureColor] setStroke];
  [embossPath stroke];
}

- (void)drawTextWithRect:(CGRect)textRect {
  NSFont *font = [NSFont fontWithName:@"Helvetica Bold" size:(CGRectGetHeight(textRect) / 2)];
  NSColor *color = [NSColor colorWithCalibratedWhite:0 alpha:0.2];
  NSArray *objects = [NSArray arrayWithObjects:font, color, nil];
  NSArray *keys = [NSArray arrayWithObjects:NSFontAttributeName, NSForegroundColorAttributeName, nil];
  NSDictionary *attributes = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
  NSString *string = @"Paste";
  CGSize size = [string sizeWithAttributes:attributes];
  CGFloat widthDelta = (CGRectGetWidth(textRect) - size.width) / 2;
  CGFloat heightDelta = (CGRectGetHeight(textRect) - size.height) / 2;
  CGRect rect = CGRectInset(textRect, widthDelta, heightDelta);
  [string drawInRect:rect withAttributes:attributes];
}

@end

@implementation CBPasteView(Overridden)

- (void)mouseUp:(NSEvent *)theEvent {
  [self setNeedsDisplay:YES];
  [delegate pasteViewClicked];
}

- (void)drawRect:(NSRect)aRect { 
  CGRect bounds = [self bounds];
  [self drawBorderWithRect:CGRectInset(bounds, 32, 16)];
  [self drawTextWithRect:CGRectInset(bounds, 32, 32)];
}

- (void)dealloc {
  [delegate release];
  [super dealloc];
}

@end

@implementation CBPasteView

- (id)initWithFrame:(CGRect)aRect delegate:(id <CBItemViewDelegate>)anObject {
  self = [super initWithFrame:aRect];
  if (self != nil) {
    delegate = [anObject retain];
    [self addTrackingArea:[self createTrackingAreaWithRect:aRect]];
  }
  return self;
}

@end