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

- (void)setText:(NSString *)aString;

- (void)setFontSize:(CGFloat)fontSize;

@end