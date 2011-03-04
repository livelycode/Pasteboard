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
  NSTrackingArea *buttonArea;
  NSInteger index;
  CBItemViewStyle style;
  BOOL noteHightlighted;
  BOOL noteBacklighted;
  BOOL buttonIsHighlighted;
}

- (id)initWithFrame:(CGRect)aRect index:(NSInteger)itemIndex style:(CBItemViewStyle)aStyle;

- (void)setContent:(NSAttributedString *)aString;

- (void)setDelegate:(id <CBItemViewDelegate>)anObject;

- (void)startDragWithEvent:(NSEvent *)anEvent object:(id <NSPasteboardWriting>)anObject;

@end

@interface CBItemView(Overridden)

- (void)mouseDown:(NSEvent *)theEvent;

- (void)mouseDragged:(NSEvent *)theEvent;

- (void)mouseEntered:(NSEvent *)theEvent;

- (void)mouseExited:(NSEvent *)theEvent;

- (void)drawRect:(NSRect)aRect;

@end

@interface CBItemView(Delegation)

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)isLocal;

- (BOOL)ignoreModifierKeysWhileDragging;

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender;

- (void)draggingExited:(id <NSDraggingInfo>)sender;

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender;

@end