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
  [[NSColor woodHighlightColor] setStroke];
  [highlightPath stroke];
  
  NSBezierPath *borderPath = [NSBezierPath bezierPathWithRoundedRect:aRect xRadius:16 yRadius:16];
  [borderPath setLineWidth:width+2];
  [[NSColor woodBorderColor] setStroke];
  [borderPath stroke];
  
  NSBezierPath *embossPath = [NSBezierPath bezierPathWithRoundedRect:aRect xRadius:16 yRadius:16];
  [embossPath setLineWidth:width];
  [[NSColor woodBackgroundColor] setStroke];
  [embossPath stroke];
  [[NSColor woodStructureColor] setStroke];
  [embossPath stroke];
}

- (void)drawTextWithRect:(CGRect)textRect color:(NSColor *)aColor offset:(CGFloat)anOffset strokeWidth:(NSUInteger)aWidth {
  NSFont *font = [NSFont fontWithName:@"Lucida Grande Bold" size:(CGRectGetHeight(textRect) / 2)];
  NSString *string = @"Paste";
  NSNumber *strokeWidth = [NSNumber numberWithUnsignedInteger:aWidth];
  NSArray *objects = [NSArray arrayWithObjects:font, aColor, strokeWidth, nil];
  NSArray *keys = [NSArray arrayWithObjects:NSFontAttributeName, NSForegroundColorAttributeName, NSStrokeWidthAttributeName, nil];
  NSDictionary *attributes = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
  CGSize size = [string sizeWithAttributes:attributes];
  CGFloat widthDelta = (CGRectGetWidth(textRect) - size.width) / 2;
  CGFloat heightDelta = (CGRectGetHeight(textRect) - size.height) / 2;
  CGRect rect = CGRectInset(textRect, widthDelta, heightDelta);
  [string drawInRect:CGRectOffset(rect, 0, anOffset) withAttributes:attributes];
}

@end

@implementation CBPasteView(Overridden)

- (void)mouseUp:(NSEvent *)theEvent {
  [self setNeedsDisplay:YES];
  [delegate pasteViewClicked];
}
  
- (void)drawRect:(NSRect)aRect { 
  CGRect frame = CGRectInset([self bounds], 32, 16);
  NSColor *background = [NSColor woodBackgroundColor];
  NSColor *border = [NSColor woodBorderColor];
  NSColor *highlight = [NSColor woodHighlightColor];
  NSColor *structure = [NSColor woodStructureColor];
  [self drawBorderWithRect:frame];
  [self drawTextWithRect:frame color:highlight offset:-1 strokeWidth:0];
  [self drawTextWithRect:frame color:background offset:0 strokeWidth:0];
  [self drawTextWithRect:frame color:structure offset:0 strokeWidth:0];
  [self drawTextWithRect:frame color:border offset:0 strokeWidth:1];
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