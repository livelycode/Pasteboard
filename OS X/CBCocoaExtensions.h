#import "Cocoa.h"

@interface NSView(CBCocoaExtensions)

- (CALayer *)snapshot;

@end

@interface NSColor(CBCocoaExtensions)

+ (NSColor *)woodColor;
+ (NSColor *)woodStructureColor;
+ (NSColor *)woodBackgroundColor;
+ (NSColor *)woodHighlightColor;
+ (NSColor *)woodBorderColor;

- (NSColor *)brightenWithLevel:(CGFloat)aLevel;
- (NSColor *)shadeWithLevel:(CGFloat)aLevel;

@end