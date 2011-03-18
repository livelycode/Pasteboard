#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@interface CBItemView : NSView
{
  @private
  id delegate;
  NSString *string;
  NSMutableArray *animationLayers;
  BOOL mouseDown;
}

- (id)initWithFrame:(CGRect)aRect content:(NSString*)content delegate:(id <CBItemViewDelegate>)anObject;

@end	

@interface CBItemView(Overridden)

- (void)mouseUp:(NSEvent *)theEvent;
- (void)drawRect:(NSRect)aRect;

@end

@interface CBItemView(Delegation)

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag;

@end

@interface CBItemView(Private)
- (NSTrackingArea *)trackingAreaWithRect:(CGRect)aRect;
- (NSBezierPath *)notePathWithRect:(CGRect)noteRect;
- (void)drawNoteWithPath:(NSBezierPath *)aPath;
- (void)drawBorderWithPath:(NSBezierPath *)aPath;
- (void)drawTextAtRect:(CGRect)textRect;
- (CALayer *)animationLayerWithFrame:(CGRect)aRect;
- (void)fadeOut;
@end