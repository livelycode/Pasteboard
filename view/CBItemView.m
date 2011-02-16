#import "Cloudboard.h"

@implementation CBItemView

- (id)initWithContentSize:(CGSize)aSize
{
    self = [super initWithFrame:CGRectMake(0, 0, aSize.width, aSize.height)];
    if (self != nil)
    {
        size = aSize;
        
        textField = [[NSTextField alloc] initWithFrame:CGRectZero];
        [textField setBackgroundColor:[NSColor clearColor]];
                
        [self setPadding:0];
        [self addSubview:textField];
    }
    return self;
}

- (void)setPadding:(CGFloat)padding
{
    CGFloat pageWidth = size.width - (2 * padding);
    CGFloat pageHeight = size.height - (2 * padding);
    CGRect pageFrame = CGRectMake(padding, padding, pageWidth, pageHeight);
    [textField setFrame:pageFrame];
}

- (void)setPageColor:(NSColor *)aColor
{
    [textField setBackgroundColor:aColor];
}

- (void)setShadowWithOpacity:(CGFloat)anOpacity
                      radius:(CGFloat)aRaduis
                      offset:(CGFloat)anOffset
{
    NSShadow *pageShadow = [[NSShadow alloc] init];
    [pageShadow setShadowColor:[NSColor colorWithCalibratedWhite:0
                                                           alpha:anOpacity]];
    [pageShadow setShadowBlurRadius:aRaduis];
    [pageShadow setShadowOffset:CGSizeMake(0, (-1) * anOffset)];
    [textField setShadow:pageShadow];
}

- (void)setText:(NSAttributedString *)aString;
{
    [textField setStringValue:@"foo"];
}

@end