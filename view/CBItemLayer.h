#import "Cocoa.h"

@interface CBItemLayer : CALayer
{
	@private
    CALayer *pageLayer;
    CATextLayer *textLayer;
    CGSize size;
}

- (id)initWithWithContentSize:(CGSize)aSize;

- (void)setPadding:(CGFloat)padding;

- (void)setShadowWithOpacity:(CGFloat)anOpacity
                      radius:(CGFloat)aRaduis
                      offset:(CGFloat)anOffset;

- (void)setPageColor:(CGColorRef)colorRef;

- (void)setText:(NSAttributedString *)aString;

- (void)setFontSize:(CGFloat)fontSize;

@end