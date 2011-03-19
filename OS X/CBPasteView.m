#import "Cloudboard.h"

@implementation CBPasteView(Private)

- (NSTrackingArea *)createTrackingAreaWithRect:(CGRect)aRect {
  NSTrackingAreaOptions options = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
  return [[NSTrackingArea alloc] initWithRect:aRect options:options owner:self userInfo:nil];
}

- (void)drawBorderWithRect:(CGRect)aRect {
  [NSGraphicsContext saveGraphicsState];
  NSShadow* shadow = [[[NSShadow alloc] init] autorelease];
  [shadow setShadowOffset:CGSizeMake(0, -2)];
  [shadow setShadowBlurRadius:2];
  [shadow setShadowColor:[NSColor colorWithCalibratedWhite:0 alpha:0.4]];
  [shadow set];
  [[NSColor colorWithDeviceWhite:0.9 alpha:1] setStroke];
  NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:aRect xRadius:16 yRadius:16];
  CGFloat width = CGRectGetWidth(aRect);
  [path setLineWidth:(width/32)];
  CGFloat dash[2] = {(width/12), (width/64)};
  [path setLineDash:dash count:2 phase:0];
  [path stroke];
  [NSGraphicsContext restoreGraphicsState];
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