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
  [string drawInRect:textRect withAttributes:nil];
}

- (void)fadeOut {
  NSView *rootView = [[self window] contentView];
  NSView *clipboardView = [self superview];
  CGRect bounds = [self bounds];
  CGRect frame = [self frame];
  NSData *data = [self dataWithPDFInsideRect:bounds];
  NSImage *image = [[NSImage alloc] initWithData:data];
  CGRect newStartFrame = [rootView convertRect:frame fromView:clipboardView];
  NSImageView *imageView = [[NSImageView alloc] initWithFrame:newStartFrame];
  [imageView setWantsLayer:YES];
  [imageView setImage:image];
  [imageView setImageScaling:NSImageScaleAxesIndependently];
  [rootView addSubview:imageView];
  CGRect newFrame = CGRectInset(newStartFrame, CGRectGetWidth(newStartFrame)*-0.1, CGRectGetHeight(newStartFrame)*-0.1);
  
  CABasicAnimation *zoom = [CABasicAnimation animationWithKeyPath:@"frameSize"];
  [zoom setDuration:3];
  CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"alphaValue"];
  [fade setBeginTime:1];
  [fade setDuration:1];
  [fade setToValue:[NSNumber numberWithFloat:0.5]];
  CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
  [group setAnimations:[NSArray arrayWithObjects:zoom, fade, nil]];
  [group setDuration:3];
  [imageView setAnimations:[NSDictionary dictionaryWithObject:zoom forKey:@"frameSize"]];
  [[imageView animator] setFrame:newFrame];
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

@implementation CBItemView

- (id)initWithFrame:(CGRect)aRect index:(NSInteger)itemIndex content:(NSString*)content delegate:(id <CBItemViewDelegate>)anObject {
  self = [super initWithFrame:aRect];
  if (self != nil) {
    index = itemIndex;
    string = content;
    delegate = anObject;
    mouseDown = NO;
    [self addTrackingArea:[self createTrackingAreaWithRect:aRect]];
  }
  return self;
}

@end