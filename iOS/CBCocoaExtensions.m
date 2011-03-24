#import "CBCocoaExtensions.h"

@implementation UIColor(CBCocoaExtensions)

+ (UIColor *)color8BitWithRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue {
  CGFloat resolution = 255.0;
  return [self colorWithRed:(red/resolution) green:(green/resolution) blue:(blue/resolution) alpha:1];
}

+ (UIColor *)noteColor {
  return [self color8BitWithRed:229 green:191 blue:102];
} 

+ (UIColor *)woodColor {
  return [self color8BitWithRed:180 green:120 blue:50];
}

+ (UIColor *)woodStructureColor {
  return [self colorWithPatternImage:[UIImage imageNamed:@"Structure.png"]];
}

+ (UIColor *)woodBackgroundColor {
  return [[self woodColor] shadowWithLevel:0.3];
}

+ (UIColor *)woodHighlightColor {
  return [[self woodColor] brightenWithLevel:0.4];
}

+ (UIColor *)woodBorderColor {
  return [[self woodColor] shadowWithLevel:0.5];
}

- (CGColorSpaceRef)colorSpace {
  return CGColorGetColorSpace([self CGColor]);
}

- (CGColorSpaceModel)colorSpaceModel {
  return CGColorSpaceGetModel([self colorSpace]);
}

- (NSUInteger)numberOfComponents {
  return CGColorGetNumberOfComponents([self CGColor]);
}

- (void)getComponents:(CGFloat *)components {
  memcpy(components, CGColorGetComponents([self CGColor]), [self numberOfComponents]*sizeof(CGFloat));
}

- (CGFloat)redComponent {
  NSAssert1([self colorSpaceModel] == kCGColorSpaceModelRGB, @"%@ must be an RGB color", self);
  return CGColorGetComponents([self CGColor])[0];
}

- (CGFloat)greenComponent {
  NSAssert1([self colorSpaceModel] == kCGColorSpaceModelRGB, @"%@ must be an RGB color", self);
  return CGColorGetComponents([self CGColor])[1];
}

- (CGFloat)blueComponent {
  NSAssert1([self colorSpaceModel] == kCGColorSpaceModelRGB, @"%@ must be an RGB color", self);
  return CGColorGetComponents([self CGColor])[2];
}

- (CGFloat)alphaComponent {
  return CGColorGetAlpha([self CGColor]);
}

- (void)getHue:(CGFloat *)hue saturation:(CGFloat *)saturation brightness:(CGFloat *)brightness alpha:(CGFloat *)alpha {
  const CGFloat *rgba = CGColorGetComponents([self CGColor]);
  NSUInteger max = 0;
  for (NSUInteger i = 1; i < 3; i++) {
    if (rgba[i] > rgba[max]) max = i;
  }
  if (brightness) *brightness = rgba[max];
  if (rgba[max] != 0) {
    CGFloat delta = rgba[max] - MIN(rgba[0], MIN(rgba[1], rgba[2]));
    if (saturation) *saturation = delta/rgba[max];
    if (hue) {
      switch (max) {
        case 0:
          *hue = (rgba[1] - rgba[2])/delta;
          break;
        case 1:
          *hue = 2 + (rgba[2] - rgba[0])/delta;
          break;
        case 2:
          *hue = 4 + (rgba[0] - rgba[1])/delta;
      }
      *hue /= 6;
      if (*hue < 0) *hue += 1;
    }
  }
  else {
    if (saturation) *saturation = 0;
    if (hue) *hue = -1;
  }
  if (alpha) *alpha = [self alphaComponent];
}

- (CGFloat)hueComponent {
  CGFloat values[4];
  [self getHue:&values[0] saturation:&values[1] brightness:&values[2] alpha:&values[3]];
  return values[0];
}

- (CGFloat)saturationComponent {
  CGFloat values[4];
  [self getHue:&values[0] saturation:&values[1] brightness:&values[2] alpha:&values[3]];
  return values[1];
}

- (CGFloat)brightnessComponent {
  CGFloat values[4];
  [self getHue:&values[0] saturation:&values[1] brightness:&values[2] alpha:&values[3]];
  return values[2];
}

- (UIColor *)brightenWithLevel:(CGFloat)level {
  const CGFloat* components = CGColorGetComponents([self CGColor]);
  CGFloat red = components[0];
  CGFloat green = components[1];
  CGFloat blue = components[2];
  CGFloat alpha = components[3];
  return [UIColor colorWithRed:((1-level)*red+level) green:((1-level)*green+level) blue:((1-level)*blue+level) alpha:alpha];
}

- (UIColor *)shadowWithLevel:(CGFloat)level {
  const CGFloat* components = CGColorGetComponents([self CGColor]);
  CGFloat red = components[0];
  CGFloat green = components[1];
  CGFloat blue = components[2];
  CGFloat alpha = components[3];
  return [UIColor colorWithRed:((1-level)*red) green:((1-level)*green) blue:((1-level)*blue) alpha:alpha];
}

- (UIColor *)saturateWithLevel:(CGFloat)aLevel {
  CGFloat hue = [self hueComponent];
  CGFloat saturation = [self saturationComponent] + aLevel;
  CGFloat brightness = [self brightnessComponent];
  return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
