#import "Cocoa.h"

@interface UIColor(CBCocoaExtensions)
+ (UIColor *)color8BitWithRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue;
+ (UIColor *)noteColor;
+ (UIColor *)woodColor;
+ (UIColor *)woodStructureColor;
+ (UIColor *)woodBackgroundColor;
+ (UIColor *)woodHighlightColor;
+ (UIColor *)woodBorderColor;

- (CGColorSpaceRef)colorSpace;
- (CGColorSpaceModel)colorSpaceModel;
- (NSUInteger)numberOfComponents;
- (void)getComponents:(CGFloat *)components;
- (CGFloat)redComponent;
- (CGFloat)greenComponent;
- (CGFloat)greenComponent;
- (CGFloat)blueComponent;
- (CGFloat)alphaComponent;
- (void)getHue:(CGFloat *)hue saturation:(CGFloat *)saturation brightness:(CGFloat *)brightness alpha:(CGFloat *)alpha;
- (CGFloat)hueComponent;
- (CGFloat)saturationComponent;
- (CGFloat)brightnessComponent;
- (UIColor *)brightenWithLevel:(CGFloat)level;
- (UIColor *)shadowWithLevel:(CGFloat)level;
- (UIColor *)saturateWithLevel:(CGFloat)aLevel;
@end