#import "Cocoa.h"

@interface CBClipboardView : NSView {
  @private
}	

@end

@interface CBClipboardView(Overriden)

- (void)drawRect:(NSRect)rect;

@end