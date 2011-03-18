#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@interface CBPasteView : NSView
{
@private
  id delegate;
  CGFloat lineWidth;
}
- (id)initWithFrame:(CGRect)aRect delegate:(id <CBItemViewDelegate>)anObject;
@end

@interface CBPasteView(Overridden)
- (void)mouseUp:(NSEvent *)theEvent;
- (void)drawRect:(NSRect)aRect;
@end

@interface CBPasteView(Private)
- (NSTrackingArea *)createTrackingAreaWithRect:(CGRect)aRect;
- (NSBezierPath *)notePathWithRect:(CGRect)noteRect;
- (void)drawBorderWithPath:(NSBezierPath *)aPath;
- (void)drawTextAtRect:(CGRect)textRect;
@end