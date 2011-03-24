#import "CBCocoaExtensions.h"

@implementation NSView (CBCocoaExtensions)

- (CALayer *)snapshot {
  CGRect bounds = [self bounds];
  NSInteger pixelsWide = CGRectGetWidth(bounds);
  NSInteger pixelsHigh = CGRectGetHeight(bounds);
  NSInteger bytesPerRow = pixelsWide * 4;
  CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
  CGContextRef imageContext = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh, 8, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
  [[self layer] renderInContext:imageContext];
  CGImageRef image = CGBitmapContextCreateImage(imageContext);
  CALayer *layer = [CALayer layer];	
  [layer setFrame:[self frame]];
  [layer setContents:(id)image];
  
  CGColorSpaceRelease(colorSpace);
  CGContextRelease(imageContext);
  CGImageRelease(image);
  return layer;
}

@end

@implementation NSColor(CBCocoaExtensions)

+ (NSColor *)colorWithRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue {
  CGFloat resolution = 255.0;
  return [self colorWithCalibratedRed:(red/resolution) green:(green/resolution) blue:(blue/resolution) alpha:1];
}

+ (NSColor *)noteColor {
  return [self colorWithRed:229 green:191 blue:102];
} 

+ (NSColor *)woodColor {
  return [self colorWithRed:180 green:120 blue:50];
}

+ (NSColor *)woodStructureColor {
   return [self colorWithPatternImage:[NSImage imageNamed:@"Structure.png"]];
}

+ (NSColor *)woodBackgroundColor {
  return [[self woodColor] shadeWithLevel:0.3];
}

+ (NSColor *)woodHighlightColor {
  return [[self woodColor] brightenWithLevel:0.4];
}

+ (NSColor *)woodBorderColor {
  return [[self woodColor] shadowWithLevel:0.5];
}

- (NSColor *)brightenWithLevel:(CGFloat)aLevel {
  return [self blendedColorWithFraction:aLevel ofColor:[NSColor whiteColor]];
}

- (NSColor *)shadeWithLevel:(CGFloat)aLevel {
  return [self blendedColorWithFraction:aLevel ofColor:[NSColor blackColor]];
}

- (NSColor *)saturateWithLevel:(CGFloat)aLevel {
  CGFloat hue = [self hueComponent];
  CGFloat saturation = [self saturationComponent] + aLevel;
  CGFloat brightness = [self brightnessComponent];
  return [NSColor colorWithCalibratedHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
