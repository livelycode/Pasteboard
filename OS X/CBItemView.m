#import "Cloudboard.h"

@implementation CBItemView(Private)

- (NSTrackingArea *)createTrackingAreaWithRect:(CGRect)aRect {
  NSTrackingAreaOptions options = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
  return [[NSTrackingArea alloc] initWithRect:aRect options:options owner:self userInfo:nil];
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
  NSShadow* shadow = [[NSShadow alloc] init];
  [shadow setShadowOffset:CGSizeMake(0, -2)];
  [shadow setShadowBlurRadius:8];
  [shadow setShadowColor:[NSColor colorWithCalibratedWhite:0 alpha:0.4]];
  [shadow set];
  [aPath fill];
  NSColor *endingColor = [NSColor colorWithCalibratedRed:0.9 green:0.8 blue:0.4 alpha:1];
  NSColor *startingColor = [endingColor highlightWithLevel:0.3];
  NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startingColor endingColor:endingColor];
  [gradient drawInBezierPath:aPath angle:270];
  [NSGraphicsContext restoreGraphicsState];
}

- (void)drawBorderWithPath:(NSBezierPath *)aPath {
  [aPath addClip];
  [[NSColor colorWithCalibratedWhite:1 alpha:0.3] setStroke];
  [aPath setLineWidth:2];
  [aPath stroke];
}

- (void)drawTextAtRect:(CGRect)textRect {
  NSAttributedString* attrString = [[NSAttributedString alloc] initWithString: string];
  [attrString drawInRect:textRect];
}

- (void)fadeOut {
  NSView *rootView = [[self window] contentView];
  NSView *clipboardView = [self superview];
  CGRect frame = [self frame];
  
  NSImage *image = [[NSImage alloc] initWithData:[self dataWithPDFInsideRect:[self bounds]]];  
  CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[image TIFFRepresentation], NULL);
  CGImageRef maskRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
    
  CALayer *layer = [[CALayer alloc] init];
  [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
  [layer setNeedsDisplay];
  [layer setOpacity:0];
  [layer setFrame:[rootView convertRect:frame fromView:clipboardView]];
  [layer setContents:(id)maskRef];
  [CBMainWindowController addSublayerToRootLayer:layer];
  
  CABasicAnimation *zoom = [CABasicAnimation animationWithKeyPath:@"transform"];
  [zoom setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.3)]];
  CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
  [fade setFromValue:[NSNumber numberWithFloat:0.3]];
  [fade setToValue:[NSNumber numberWithFloat:0]];
  CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
  [group setDelegate:self];
  [group setAnimations:[NSArray arrayWithObjects:zoom, fade, nil]];
  [group setDuration:0.3];
  [layer addAnimation:group forKey:@"transform"];
  [animationLayers insertObject:layer atIndex:0];
}

@end

@implementation CBItemView(Overridden)

- (void)mouseUp:(NSEvent *)theEvent {
  mouseDown = NO;
  [self setNeedsDisplay:YES];
  [delegate itemViewClicked:self index:index];
  [self fadeOut];
}

- (void)drawRect:(NSRect)aRect {
  CGRect noteRect = CGRectInset([self bounds], 24, 24);
  NSBezierPath *notePath = [self notePathWithRect:noteRect];
  [self drawNoteWithPath:notePath];
  [self drawBorderWithPath:notePath];
  [self drawTextAtRect:CGRectInset(noteRect, 8, 8)];
}

@end

@implementation CBItemView(Delegation)

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
  [[animationLayers objectAtIndex:0] removeFromSuperlayer];	
}

/*- (void)displayLayer:(CALayer *)layer {
  
}*/

@end

@implementation CBItemView

- (id)initWithFrame:(CGRect)aRect index:(NSInteger)itemIndex content:(NSString*)content delegate:(id <CBItemViewDelegate>)anObject {
  self = [super initWithFrame:aRect];
  if (self != nil) {
    index = itemIndex;
    string = content;
    delegate = anObject;
    mouseDown = NO;
    [self addTrackingArea:[self createTrackingAreaWithRect:aRect]];
    animationLayers = [NSMutableArray array];
  }
  return self;
}

@end