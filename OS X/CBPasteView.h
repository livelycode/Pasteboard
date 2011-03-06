#import "Cocoa.h"

@interface CBPasteView : NSView
{
  @private
  id delegate;
  NSTrackingArea *noteArea;
  NSInteger index;
  BOOL mouseOver;
  BOOL mouseDown;
}
- (id)initWithFrame:(CGRect)aRect index:(NSInteger)itemIndex delegate:(id)anObject;
@end

@interface CBPasteView(Overridden)
- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseEntered:(NSEvent *)theEvent;
- (void)mouseExited:(NSEvent *)theEvent;
- (void)drawRect:(NSRect)aRect;
@end