#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@interface CBItemView : NSView
{
    @private
    id delegate; 
    NSTextField *textField;
    NSButton *button;
    NSAttributedString *string;
    NSGradient *gradient;
    BOOL visible;
    BOOL highlighted;
}

- (void)mouseDown:(NSEvent *)theEvent;

- (void)mouseDragged:(NSEvent *)theEvent;

- (id)initWithFrame:(NSRect)aRect;

- (void)setDelegate:(id <CBItemViewDelegate>)anObject;

- (void)setText:(NSAttributedString *)aString;

- (NSAttributedString *)text;

- (void)setVisible:(BOOL)isVisible;

- (BOOL)isVisible;

- (void)drawRect:(NSRect)aRect;

- (void)startDragWithEvent:(NSEvent *)anEvent
                    object:(id <NSPasteboardWriting>)anObject;

@end

@interface CBItemView(Delegation)

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)isLocal;

- (BOOL)ignoreModifierKeysWhileDragging;

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender;

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender;

- (void)draggingExited:(id <NSDraggingInfo>)sender;

@end

@interface CBItemView(Private)

- (void)dismiss;

@end