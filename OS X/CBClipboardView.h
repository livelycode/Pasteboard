#import "Cocoa.h"

@interface CBClipboardView : NSView {
  CGImageRef snapshot;
}	

@end

@interface CBClipboardView(Overriden)
- (id)initWithFrame:(NSRect)aRect;
- (void)drawRect:(NSRect)rect;
@end

@interface CBClipboardView(Private)
- (void)drawBackgroundWithPath:(NSBezierPath *)aPath;
- (void)drawBorderWithPath:(NSBezierPath *)aPath;
@end