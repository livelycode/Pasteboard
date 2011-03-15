#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@interface CBItemView : NSView
{
  @private
  id delegate;
  NSString *string;
  NSTrackingArea *noteArea;
  NSMutableArray *animationLayers;
  CGImageRef snapshot;
  BOOL mouseOver;
  BOOL mouseDown;
  BOOL noteBacklighted;
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