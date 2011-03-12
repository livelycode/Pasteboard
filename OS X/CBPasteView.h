#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@interface CBPasteView : NSView
{
@private
  id delegate;
  NSTrackingArea *noteArea;
  CGFloat lineWidth;
}

- (id)initWithFrame:(CGRect)aRect delegate:(id <CBItemViewDelegate>)anObject;

@end

@interface CBPasteView(Overridden)

- (void)mouseUp:(NSEvent *)theEvent;
- (void)drawRect:(NSRect)aRect;

@end