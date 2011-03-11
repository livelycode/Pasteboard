#import "Cloudboard.h"

@implementation CBPasteView(Private)

- (NSTrackingArea *)createTrackingAreaWithRect:(CGRect)aRect {
  NSTrackingAreaOptions options = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
  return [[NSTrackingArea alloc] initWithRect:aRect options:options owner:self userInfo:nil];
}

- (NSBezierPath *)notePathWithRect:(CGRect)noteRect {
  return [NSBezierPath bezierPathWithRoundedRect:noteRect xRadius:16 yRadius:16];
}

- (void)drawBorderWithPath:(NSBezierPath *)aPath {
  [NSGraphicsContext saveGraphicsState];
  NSShadow* shadow = [[NSShadow alloc] init];
  [shadow setShadowOffset:CGSizeMake(0, -2)];
  [shadow setShadowBlurRadius:2];
  [shadow setShadowColor:[NSColor colorWithCalibratedWhite:0 alpha:0.4]];
  [shadow set];
  [[NSColor colorWithDeviceWhite:1 alpha:0.8] setStroke];
  [aPath setLineWidth:6];
  CGFloat dash[2] = {24, 6};
  [aPath setLineDash:dash count:2 phase:0];
  [aPath stroke];
}

- (void)drawTextAtRect:(CGRect)textRect {
  NSFont *font = [NSFont fontWithName:@"Helvetica" size:56];
  NSColor *color = [NSColor whiteColor];
  NSArray *objects = [NSArray arrayWithObjects:font, color, nil];
  NSArray *keys = [NSArray arrayWithObjects:NSFontAttributeName, NSForegroundColorAttributeName, nil];
  NSDictionary *attributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
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
  [delegate itemViewClicked:self index:index];
}

- (void)drawRect:(NSRect)aRect {
  CGRect noteRect = CGRectInset([self bounds], 32, 32);
  [self drawBorderWithPath:[self notePathWithRect:noteRect]];
  [self drawTextAtRect:noteRect];
}

@end

@implementation CBPasteView

- (id)initWithFrame:(CGRect)aRect delegate:(id <CBItemViewDelegate>)anObject {
  self = [super initWithFrame:aRect];
  if (self != nil) {
    delegate = anObject;
    [self addTrackingArea:[self createTrackingAreaWithRect:aRect]];
  }
  return self;
}

@end