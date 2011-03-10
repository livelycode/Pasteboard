#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@interface CBItemView : NSView
{
  @private
  id delegate;
  NSAttributedString *string;
  NSTrackingArea *noteArea;
  NSInteger index;
  BOOL mouseOver;
  BOOL mouseDown;
  BOOL noteBacklighted;
}

- (id)initWithFrame:(CGRect)aRect index:(NSInteger)itemIndex content:(NSAttributedString*)content delegate:(id <CBItemViewDelegate>)anObject;

@end

@interface CBItemView(Overridden)

- (void)mouseUp:(NSEvent *)theEvent;
- (void)drawRect:(NSRect)aRect;

@end