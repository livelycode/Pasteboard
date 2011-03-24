#import "Cocoa.h"

@interface NSView(CBCocoaExtensions)

- (CALayer *)snapshot;

@end

@interface NSColor(CBCocoaExtensions)

+ (NSColor *)colorWithRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue;
+ (NSColor *)noteColor;
+ (NSColor *)woodColor;
+ (NSColor *)woodStructureColor;
+ (NSColor *)woodBackgroundColor;
+ (NSColor *)woodHighlightColor;
+ (NSColor *)woodBorderColor;

- (NSColor *)brightenWithLevel:(CGFloat)aLevel;
- (NSColor *)shadeWithLevel:(CGFloat)aLevel;
- (NSColor *)saturateWithLevel:(CGFloat)aLevel;

@end