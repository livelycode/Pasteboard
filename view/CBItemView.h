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
}

- (void)mouseDown:(NSEvent *)theEvent;

- (id)initWithFrame:(NSRect)aRect;

- (void)setDelegate:(id <CBItemViewDelegate>)anObject;

- (void)setText:(NSAttributedString *)aString;

- (void)drawRect:(NSRect)aRect;

@end

@interface CBItemView(Private)

- (void)dismiss;

@end