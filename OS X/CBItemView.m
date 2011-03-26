#import "Cloudboard.h"

@implementation CBItemView(Private)

- (NSTrackingArea *)trackingAreaWithRect:(CGRect)aRect {
  NSTrackingAreaOptions options = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
  return [[[NSTrackingArea alloc] initWithRect:aRect options:options owner:self userInfo:nil] autorelease];
}

- (NSBezierPath *)notePathWithRect:(CGRect)noteRect {
  NSBezierPath *path = [NSBezierPath bezierPath];
  [path moveToPoint:CGPointMake(CGRectGetMinX(noteRect), CGRectGetMinY(noteRect))];
  [path lineToPoint:CGPointMake(CGRectGetMaxX(noteRect), CGRectGetMinY(noteRect))];
  [path lineToPoint:CGPointMake(CGRectGetMaxX(noteRect), CGRectGetMaxY(noteRect))];
  [path lineToPoint:CGPointMake(CGRectGetMinX(noteRect), CGRectGetMaxY(noteRect))];
  [path closePath];
  return path;
}

- (void)drawNoteWithPath:(NSBezierPath *)aPath {
  [NSGraphicsContext saveGraphicsState];
  NSShadow* shadow = [[[NSShadow alloc] init] autorelease];
  [shadow setShadowOffset:CGSizeMake(0, -2)];
  [shadow setShadowBlurRadius:8];
  [shadow setShadowColor:[NSColor colorWithCalibratedWhite:0 alpha:0.4]];
  [shadow set];
  [aPath fill];
  NSColor *startingColor = [NSColor noteColor];
  NSColor *endingColor = [startingColor saturateWithLevel:0.2];
  NSGradient *gradient = [[[NSGradient alloc] initWithStartingColor:startingColor endingColor:endingColor] autorelease];
  [gradient drawInBezierPath:aPath angle:270];
  [NSGraphicsContext restoreGraphicsState];
}

- (void)drawBorderWithPath:(NSBezierPath *)aPath {
  [aPath addClip];
  [[[NSColor noteColor] brightenWithLevel:0.2] setStroke];
  [aPath setLineWidth:2];
  [aPath stroke];
}

- (void)drawTextAtRect:(CGRect)textRect {
  NSAttributedString* attrString = [[[NSAttributedString alloc] initWithString: string] autorelease];
  [attrString drawInRect:textRect];
}

- (CALayer *)animationLayerWithFrame:(CGRect)aRect {
  CABasicAnimation *zoom = [CABasicAnimation animationWithKeyPath:@"transform"];
  [zoom setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.3)]];
  CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
  [fade setFromValue:[NSNumber numberWithDouble:0.5]];
  [fade setToValue:[NSNumber numberWithFloat:0]];
  CAAnimationGroup *group = [[[CAAnimationGroup alloc] init] autorelease];
  [group setDelegate:self];
  [group setAnimations:[NSArray arrayWithObjects:zoom, fade, nil]];
  [group setDuration:0.5];
  [group setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
  CALayer *layer = [self snapshot];
  [layer setFrame:aRect];
  [layer setActions:[NSDictionary dictionaryWithObject:group forKey:@"opacity"]];
  return layer;
}

- (void)fadeOut {
  NSView *rootView = [[self window] contentView];
  NSView *clipboardView = [self superview];
  CGRect frame = [self frame];
  CALayer *layer = [self animationLayerWithFrame:[rootView convertRect:frame fromView:clipboardView]];
  [CATransaction setDisableActions:YES];
  [CBMainWindowController addSublayerToRootLayer:layer];
  [CATransaction setDisableActions:NO];
  [animationLayers insertObject:layer atIndex:0];
  [layer setOpacity:0];
}

@end

@implementation CBItemView(Overridden)

- (void)mouseUp:(NSEvent *)theEvent {
  mouseDown = NO;
  [self setNeedsDisplay:YES];
  [delegate itemViewClicked:self];
  [self fadeOut];
}

- (void)drawRect:(NSRect)aRect {
  NSInteger width = CGRectGetWidth(aRect) / 24;
  NSInteger height = CGRectGetHeight(aRect) / 16;
  CGRect noteRect = CGRectInset([self bounds], width, height);
  NSBezierPath *notePath = [self notePathWithRect:noteRect];
  [self drawNoteWithPath:notePath];
  [self drawBorderWithPath:notePath];
  [self drawTextAtRect:CGRectInset(noteRect, 8, 8)];
}

- (void)dealloc {
  [delegate release];
  [string release];
  [animationLayers release];
  [super dealloc];
}

@end

@implementation CBItemView(Delegation)

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
  [[animationLayers objectAtIndex:0] removeFromSuperlayer];
  [animationLayers removeObjectAtIndex:0];
}

@end

@implementation CBItemView

- (id)initWithFrame:(CGRect)aRect content:(NSString*)content delegate:(id <CBItemViewDelegate>)anObject {
  self = [super initWithFrame:aRect];
  if (self != nil) {
    string = [content retain];
    delegate = [anObject retain];
    mouseDown = NO;
    animationLayers = [[NSMutableArray alloc] init];
    [self addTrackingArea:[self trackingAreaWithRect:aRect]];
  }
  return self;
}

@end