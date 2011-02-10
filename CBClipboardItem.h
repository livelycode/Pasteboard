#import "Cocoa.h"

@interface CBClipboardItem : NSObject
{
	@private
    
    CALayer *mainLayer;
    CATextLayer *contentLayer;
    CATextLayer *descriptionLayer;
    CGSize size;
}

- (id)initWithContentSize:(CGSize)aSize;

- (void)setImageWithFile:(NSURL *)fileURL;

- (void)setColor:(NSColor *)aColor;

- (void)setText:(NSString *)aString;

- (void)setDescription:(NSString *)aString;

- (void)setFontSize:(CGFloat)fontSize;

- (CALayer *)layer;

@end
