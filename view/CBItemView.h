#import "Cocoa.h"

@interface CBItemView : NSView
{
    @private
    NSTextField *textField;
    CGSize size;
}

- (id)initWithContentSize:(CGSize)aSize;

- (void)setPadding:(CGFloat)padding;

- (void)setShadowWithOpacity:(CGFloat)anOpacity
                      radius:(CGFloat)aRaduis
                      offset:(CGFloat)anOffset;

- (void)setPageColor:(NSColor *)aColor;

- (void)setText:(NSAttributedString *)aString;

@end