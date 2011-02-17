#import "Cloudboard.h"

@implementation CBClipboardView

- (void)drawRect:(NSRect)rect
{
    [color set];
    CGRect frame = [self bounds];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:frame
                                                         xRadius:cornerRadius
                                                         yRadius:cornerRadius];
    [path fill];
    
}

- (id)initWithFrame:(CGRect)aFrame
               Rows:(NSUInteger)numberRows
            Columns:(NSUInteger)numberColumns
      itemViewClass:(Class)itemClass;
{
    self = [super initWithFrame:aFrame];
    if (self != nil)
    {
        matrix = [[CBMatrix alloc] initWithRows:numberRows
                                        columns:numberColumns];
        cornerRadius = 0;
        color = [NSColor whiteColor];
    }
    return self;
}

- (void)setCornerRadius:(CGFloat)aRadius
{
    cornerRadius = aRadius;
}

- (void)setColor:(NSColor *)aColor
{
    color = aColor;
}

- (CBItemView *)itemViewForRow:(NSUInteger)aRow
                        column:(NSUInteger)aColumn;
{   
    return [matrix objectForRow:aRow
                         column:aColumn];
}

@end
