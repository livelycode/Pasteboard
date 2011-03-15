#import "CBCocoaExtensions.h"

@implementation NSView (CBCocoaExtensions)

- (CALayer *)layerSnapshot {
  NSData *data = [self dataWithPDFInsideRect:[self bounds]];
  NSImage *image = [[NSImage alloc] initWithData:data];  
  CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[image TIFFRepresentation], NULL);
  CALayer *layer = [CALayer layer];
  [layer setFrame:[self frame]];
  [layer setContents:(id)CGImageSourceCreateImageAtIndex(source, 0, NULL)];
  return layer;
}

@end