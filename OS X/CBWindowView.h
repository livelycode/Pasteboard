#import "Cocoa.h"

@interface CBWindowView : NSView
{
  @private
  BOOL hideable;
}

- (id)initWithFrame:(NSRect)aFrame;
- (void)setHideable:(BOOL)isHideable;
- (void)mouseDown:(NSEvent *)theEvent;
- (void)drawRect:(NSRect)aRect;

@end