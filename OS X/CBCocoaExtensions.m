#import "CBCocoaExtensions.h"

@implementation NSView (CBCocoaExtensions)

- (CALayer *)snapshot {
  NSData *data = [self dataWithPDFInsideRect:[self bounds]];
  NSImage *image = [[[NSImage alloc] initWithData:data] autorelease];  
  CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[image TIFFRepresentation], NULL);
  CALayer *layer = [CALayer layer];
  [layer setFrame:[self frame]];
  [layer setContents:(id)CGImageSourceCreateImageAtIndex(source, 0, NULL)];
  return layer;
}

@end