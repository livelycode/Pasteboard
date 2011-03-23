#import "Cocoa.h"

@interface NSView(CBCocoaExtensions)

- (CALayer *)snapshot;

@end

@interface NSColor(CBCocoaExtensions)

+ (NSColor *)woodColor;
+ (NSColor *)woodStructureColor;
+ (NSColor *)woodDarkColor;
+ (NSColor *)woodLightColor;
+ (NSColor *)woodBorderColor;

@end