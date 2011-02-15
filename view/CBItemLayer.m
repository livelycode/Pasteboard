#import "Cloudboard.h"

@implementation CBItemLayer

- (id)initWithWithContentSize:(CGSize)aSize
{
    self = [super init];
    if (self != nil)
    {
        size = aSize;
        
        textLayer = [CATextLayer layer];
        [textLayer setBackgroundColor:CGColorCreateGenericGray(1, 1)];
        [textLayer setForegroundColor:CGColorCreateGenericGray(0, 1)];
        [textLayer setTruncationMode:kCATruncationEnd];
        [textLayer setAlignmentMode:kCAAlignmentLeft];
                
        pageLayer = [CALayer layer];
        [pageLayer setBackgroundColor:CGColorCreateGenericGray(1, 1)];
        [pageLayer addSublayer:textLayer];
        [self setPadding:0];
        
        [self setFrame:CGRectMake(0, 0, aSize.width, aSize.height)];
        [self addSublayer:pageLayer];
    }
    return self;
}

- (void)setPadding:(CGFloat)padding
{
    CGFloat pageWidth = size.width - (2 * padding);
    CGFloat pageHeight = size.height - (2 * padding);
    CGRect pageFrame = CGRectMake(padding, padding, pageWidth, pageHeight);
    CGRect textFrame = CGRectMake(10, 10, (pageWidth - 20), (pageHeight - 20));
    CGFloat x = size.width / 2;
    CGFloat y = size.height / 2;
    [textLayer setFrame:textFrame];
    [pageLayer setFrame:pageFrame];
    [pageLayer setPosition:CGPointMake(x, y)];
}

- (void)setShadowWithOpacity:(CGFloat)anOpacity
                      radius:(CGFloat)aRaduis
                      offset:(CGFloat)anOffset
{
    [pageLayer setShadowOpacity:anOpacity];
    [pageLayer setShadowRadius:aRaduis];
    [pageLayer setShadowOffset:CGSizeMake(0, (-1) * anOffset)];
}

- (void)setText:(NSString *)aString;
{
    [textLayer setString:aString];
}

- (void)setFontSize:(CGFloat)fontSize
{
    [textLayer setFontSize:fontSize];
}

@end