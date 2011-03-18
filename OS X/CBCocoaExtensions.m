#import "CBCocoaExtensions.h"

@implementation NSView (CBCocoaExtensions)

- (CALayer *)snapshot {
  NSData *data = [self dataWithPDFInsideRect:[self bounds]];
  NSImage *image = [[NSImage alloc] initWithData:data];  
  CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[image TIFFRepresentation], NULL);
  CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, NULL);
  CALayer *layer = [CALayer layer];
  [layer setFrame:[self frame]];
  [layer setContents:(id)imageRef];
  [image release];
  CFRelease(source);
  CFRelease(imageRef);
  return layer;
}

@end