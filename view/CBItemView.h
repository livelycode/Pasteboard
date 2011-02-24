#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@interface CBItemView : NSView
{
    @private
    id delegate;
    NSTextField *textField;
    NSButton *button;
    NSGradient *gradient;
    NSAttributedString *string;
    BOOL visible;
    BOOL highlighted;
    BOOL backlit;
}

- (id <CBItemViewDelegate>)delegate;

- (void)setDelegate:(id <CBItemViewDelegate>)anObject;

- (NSAttributedString *)text;

- (void)setText:(NSAttributedString *)aString;

- (BOOL)isVisible;

- (void)setVisible:(BOOL)isVisible;

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

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender;

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender;

- (void)draggingExited:(id <NSDraggingInfo>)sender;

@end

@interface CBItemView(Private)

- (void)dismiss;

@end