#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@interface CBPasteView : NSView
{
  @private
  id delegate;
}
- (id)initWithFrame:(CGRect)aRect delegate:(id <CBItemViewDelegate>)anObject;
@end

@interface CBPasteView(Overridden)
- (void)mouseUp:(NSEvent *)theEvent;
- (void)drawRect:(NSRect)aRect;
@end

@interface CBPasteView(Private)
- (NSTrackingArea *)createTrackingAreaWithRect:(CGRect)aRect;
- (void)drawBorderWithRect:(CGRect)aRect;
- (void)drawTextWithRect:(CGRect)textRect color:(NSColor *)aColor offset:(CGFloat)anOffset strokeWidth:(NSUInteger)aWidth;
@end