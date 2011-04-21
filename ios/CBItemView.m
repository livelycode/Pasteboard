#import "Cloudboard.h"

@implementation CBItemView(Private)

- (void)initDeviceSpecificParams {
  if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    itemFontSize = 16;
    itemPaddingX = 16;
    itemPaddingY = 24;
  } else {
    itemFontSize = 10;
    itemPaddingX = 6;
    itemPaddingY = 10;
  }
}

- (UIBezierPath *)notePathWithRect:(CGRect)noteRect {
  UIBezierPath *path = [UIBezierPath bezierPath];
  [path moveToPoint:CGPointMake(CGRectGetMinX(noteRect), CGRectGetMinY(noteRect))];
  [path addLineToPoint:CGPointMake(CGRectGetMaxX(noteRect), CGRectGetMinY(noteRect))];
  [path addLineToPoint:CGPointMake(CGRectGetMaxX(noteRect), CGRectGetMaxY(noteRect))];
  [path addLineToPoint:CGPointMake(CGRectGetMinX(noteRect), CGRectGetMaxY(noteRect))];
  [path closePath];
  return path;
}

- (void)drawBorderWithPath:(UIBezierPath *)aPath {
  [aPath addClip];
  [[[UIColor noteColor] brightenWithLevel:0.1] setStroke];
  [aPath setLineWidth:2/SCALE];
  [aPath stroke];
}

- (void)drawNoteWithPath:(UIBezierPath *)aPath {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  UIColor* shadowColor = [UIColor colorWithWhite:0 alpha:0.4];
  CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 8, [shadowColor CGColor]);
  [aPath fill];
  CGContextAddPath(context, aPath.CGPath);
  CGContextClosePath(context);
  CGContextClip(context);
  UIColor *startingColor = [UIColor noteColor];
  UIColor *endingColor = [startingColor saturateWithLevel:0.2];
  NSUInteger height = CGRectGetHeight(aPath.bounds);
  CGFloat gradientLocations[2] = { 0.0, 1.0 };
  NSMutableArray *colors = [NSMutableArray arrayWithObjects:(id)startingColor.CGColor, (id)endingColor.CGColor, nil];
  CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
  CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, gradientLocations);  
  CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, height), kCGGradientDrawsAfterEndLocation);
  CFRelease(gradient);
  CGContextRestoreGState(context);
}

- (void)drawTextAtRect:(CGRect)textRect {
  [string drawInRect:textRect withFont: [UIFont systemFontOfSize:itemFontSize]];
}

- (void)fadeOut {
  CGRect frame = [self frame];
  
  UIGraphicsBeginImageContext(self.bounds.size);
  [self.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  CGImageRef maskRef =  image.CGImage;
  CALayer *layer = [[[CALayer alloc] init] autorelease];
  [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
  [layer setNeedsDisplay];
  [layer setOpacity:0];
  [layer setFrame:frame];
  [layer setContents:(id)maskRef];
  [self.superview.layer addSublayer:layer];
  
  CABasicAnimation *zoom = [CABasicAnimation animationWithKeyPath:@"transform"];
  [zoom setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.3)]];
  CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
  [fade setFromValue:[NSNumber numberWithFloat:0.5]];
  [fade setToValue:[NSNumber numberWithFloat:0]];
  CAAnimationGroup *group = [[[CAAnimationGroup alloc] init] autorelease];
  [group setDelegate:self];
  [group setAnimations:[NSArray arrayWithObjects:zoom, fade, nil]];
  [group setDuration:0.5];
  [group setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
  [layer addAnimation:group forKey:@"transform"];
  [animationLayers insertObject:layer atIndex:0];
}

@end

@implementation CBItemView

- (id)initWithFrame:(CGRect)aRect content:(NSString*)content delegate:(id <CBItemViewDelegate>)anObject {
  self = [super initWithFrame:aRect];
  if (self != nil) {
    [self initDeviceSpecificParams];
    delegate = [anObject retain];
    string = [content retain];
    animationLayers = [[NSMutableArray alloc] init];
    [self setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer* recognizer = [[[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleTap:)] autorelease];
    [self addGestureRecognizer:recognizer];
  }
  return self;
}

- (void)moveToFrame:(CGRect)frame {
  [self setFrame:frame];
  [self setNeedsDisplay];
}

@end

@implementation CBItemView(Overridden)

- (void)drawRect:(CGRect)aRect {
  CGRect noteRect = CGRectInset([self bounds], itemPaddingX, itemPaddingY);
  UIBezierPath *notePath = [self notePathWithRect:noteRect];
  [self drawNoteWithPath:notePath];
  [self drawBorderWithPath:notePath];
  [self drawTextAtRect:CGRectInset(noteRect, 8, 8)];
}

- (void)dealloc {
  [string release];
  [delegate release];
  [animationLayers release];
  [super dealloc];
}
@end

@implementation CBItemView(Delegation)

- (void)handleTap:(UITapGestureRecognizer*)recognizer {
  [self fadeOut];
  [delegate handleTapFromItemView:self];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
  [[animationLayers objectAtIndex:0] removeFromSuperlayer];
  [animationLayers removeObjectAtIndex:0];
}

@end

