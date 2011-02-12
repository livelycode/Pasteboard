#import "Cocoa.h"

@interface CBItemLayer : CALayer
{
	@private
    NSString *itemReference;
    CATextLayer *contentLayer;
    CATextLayer *descriptionLayer;
    CGSize size;
}

- (id)initWithWithContentSize:(CGSize)aSize;

- (void)setImageWithFile:(NSURL *)fileURL;

- (void)setText:(NSString *)aString;

- (void)setDescription:(NSString *)aString;

- (void)setFontSize:(CGFloat)fontSize;

@end

