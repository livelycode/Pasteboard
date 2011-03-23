#import "CBCocoaExtensions.h"

@implementation NSView (CBCocoaExtensions)

- (CALayer *)snapshot {
  CGRect bounds = [self bounds];
  NSInteger pixelsWide = CGRectGetWidth(bounds);
  NSInteger pixelsHigh = CGRectGetHeight(bounds);
  NSInteger bytesPerRow = pixelsWide * 4;
  void *bitmapData = malloc(bytesPerRow * pixelsHigh);
  CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
  CGContextRef imageContext = CGBitmapContextCreate (bitmapData, pixelsWide, pixelsHigh, 8, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);

  [[self layer] renderInContext:imageContext];
  CALayer *layer = [CALayer layer];	
  [layer setFrame:[self frame]];
  [layer setContents:(id)CGBitmapContextCreateImage(imageContext)];
  
  CGColorSpaceRelease(colorSpace);
  return layer;
}

@end

