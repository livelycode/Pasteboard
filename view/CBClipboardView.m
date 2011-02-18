#import "Cloudboard.h"

@implementation CBClipboardView

- (id)initWithFrame:(CGRect)aFrame
               Rows:(NSUInteger)numberRows
            Columns:(NSUInteger)numberColumns
      itemViewClass:(Class)itemClass;
{
    self = [super initWithFrame:aFrame];
    if (self != nil)
    {
        rows = numberRows;
        columns = numberColumns;
        cornerRadius = 0;
        color = [NSColor whiteColor];
        
        NSUInteger numberItems = rows * columns;
        itemViews = [NSMutableArray arrayWithCapacity:numberItems];
        while (numberItems != 0)
        {
            NSView *itemView = [[itemClass alloc] initWithFrame:CGRectZero];
            [itemViews addObject:itemView];
            [self addSubview:itemView];
            numberItems = numberItems - 1;
        }
        
        [self setPadding:0];
    }
    return self;
}

- (void)drawRect:(NSRect)rect
{
    [color set];
    CGRect frame = [self bounds];
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:frame
                                                         xRadius:cornerRadius
                                                         yRadius:cornerRadius];
    [path fill];
}

- (void)setCornerRadius:(CGFloat)aRadius
{
    cornerRadius = aRadius;
}

- (void)setColor:(NSColor *)aColor
{
    color = aColor;
}

- (void)setPadding:(CGFloat)thePadding
{
    CGRect mainBounds = [self bounds];
    CGFloat itemWidth = (mainBounds.size.width - ((columns + 1) * thePadding)) / columns;
    CGFloat itemHeight = (mainBounds.size.height - ((rows + 1) * thePadding)) / rows;
    
    CGPoint origin = CGPointMake(thePadding, (mainBounds.size.height - itemHeight - thePadding));
    NSUInteger currentRow = 0;
    NSUInteger currentColumn = 0;
    
    for (NSView *itemView in itemViews)
    {
        CGFloat x = origin.x + (currentColumn * (itemWidth + thePadding));
        CGFloat y = origin.y - (currentRow * (itemHeight + thePadding));
        CGRect itemFrame = CGRectMake(x, y, itemWidth, itemHeight);
        [itemView setFrame:itemFrame];
        currentColumn = currentColumn + 1;
        if (currentColumn >= columns)
        {
            currentColumn = 0;
            currentRow = currentRow + 1;
        }
    }
}

- (NSView *)viewAtIndex:(NSUInteger)anIndex
{
    return [itemViews objectAtIndex:anIndex];
}

@end
