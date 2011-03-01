#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@interface CBItemView : NSView
{
  @private
  id delegate;
  NSAttributedString *string;
  
  NSBezierPath *notePath;
  NSBezierPath *crossPath;
  NSRect textRect;
  NSRect buttonRect;
  
  NSColor *noteDarkColor;
  NSColor *noteLightColor;
  NSColor *crossDarkColor;
  NSColor *crossLightColor;
  NSColor *backlightColor;
          
  BOOL noteVisible;
  BOOL noteHightlighted;
  BOOL noteBacklighted;
  BOOL buttonIsHighlighted;
}

- (id <CBItemViewDelegate>)delegate;

- (void)setDelegate:(id <CBItemViewDelegate>)anObject;

- (NSAttributedString *)text;

- (void)setText:(NSAttributedString *)aString;

- (BOOL)isNoteVisible;

- (void)setNoteVisible:(BOOL)visible;

- (void)startDragWithEvent:(NSEvent *)anEvent
                    object:(id <NSPasteboardWriting>)anObject;

@end

@interface CBItemView(Overridden)

- (id)initWithFrame:(NSRect)aRect;

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