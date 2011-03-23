#import "CBCocoaExtensions.h"

@implementation UIColor(CBCocoaExtensions)

- (UIColor *)highlightWithLevel:(CGFloat)level {
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

+ (UIColor *)woodColor {
  return [self colorWithRed:(172.0/255) green:(114.0/255) blue:(44.0/255) alpha:1];
}

+ (UIColor *)woodStructureColor {
   return [self colorWithPatternImage:[UIImage imageNamed:@"Structure.png"]];
}

+ (UIColor *)woodDarkColor {
  return [[self woodColor] shadowWithLevel:0.2];
}
+ (UIColor *)woodLightColor {
  return [[self woodColor] highlightWithLevel:0.2];
}
+ (UIColor *)woodBorderColor {
  return [[self woodColor] shadowWithLevel:0.3];
}

@end
