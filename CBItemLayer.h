#import "Cocoa.h"

@interface CBItemLayer : NSObject
{
	@private
    CALayer *mainLayer;
    CATextLayer *contentLayer;
    CATextLayer *descriptionLayer;
    CGSize size;
}

- (id)initWithItem:(CBItem *)anItem forTypes:(NSArray *)types;

- (void)setImageWithFile:(NSURL *)fileURL;

- (void)setColor:(NSColor *)aColor;

- (void)setText:(NSString *)aString;

- (void)setDescription:(NSString *)aString;

- (void)setFontSize:(CGFloat)fontSize;

- (CALayer *)layerWithContentSize:(CGSize)aSize;

@end