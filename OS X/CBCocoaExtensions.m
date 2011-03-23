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

@implementation NSColor(CBCocoaExtensions)

+ (NSColor *)woodColor {
  return [self colorWithCalibratedRed:(172.0/255) green:(114.0/255) blue:(44.0/255) alpha:1];
}

+ (NSColor *)woodStructureColor {
   return [self colorWithPatternImage:[NSImage imageNamed:@"Structure.png"]];
}

+ (NSColor *)woodDarkColor {
  return [[self woodColor] shadowWithLevel:0.25];
}
+ (NSColor *)woodLightColor {
  return [[self woodColor] highlightWithLevel:0.3];
}
+ (NSColor *)woodBorderColor {
  return [[self woodDarkColor] shadowWithLevel:0.2];
}

@end
