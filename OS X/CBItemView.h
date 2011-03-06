#import "Cocoa.h"
#import "CBItemViewDelegate.h"

typedef enum {
  CBItemViewStyleNote,
  CBItemViewStyleSlot
} CBItemViewStyle;

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

- (id)initWithFrame:(CGRect)aRect index:(NSInteger)itemIndex style:(CBItemViewStyle)aStyle;
- (void)setContent:(NSAttributedString *)aString;
- (void)setDelegate:(id <CBItemViewDelegate>)anObject;

@end

@interface CBItemView(Overridden)

- (void)mouseDown:(NSEvent *)theEvent;
- (void)mouseEntered:(NSEvent *)theEvent;
- (void)mouseExited:(NSEvent *)theEvent;
- (void)drawRect:(NSRect)aRect;

@end

@interface CBItemView(Delegation)

@end