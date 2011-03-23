#import "Cocoa.h"

@interface UIColor(CBCocoaExtensions)
- (UIColor *)highlightWithLevel:(CGFloat)level;
- (UIColor *)shadowWithLevel:(CGFloat)level;
+ (UIColor *)woodColor;
+ (UIColor *)woodStructureColor;
+ (UIColor *)woodDarkColor;
+ (UIColor *)woodLightColor;
+ (UIColor *)woodBorderColor;

@end