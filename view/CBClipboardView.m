#import "Cloudboard.h"

@implementation CBClipboardView

- (id)init
{
    return [self initWithRows:1
                      Columns:1];
}

- (void)drawRect:(NSRect)rect
{
    [color set];
    [NSBezierPath fillRect:[self bounds]];
}

- (id)initWithRows:(NSUInteger)rowsNumber
           Columns:(NSUInteger)columnsNumber
{
    self = [super init];
    if (self != nil)
    {
        numberRows = rowsNumber;
        numberColumns = columnsNumber;
        cornerRadius = 0;
        color = [NSColor whiteColor];
        
        items = [NSMutableArray array];
        
        NSUInteger numberItems = numberRows * numberColumns;
        CGSize clipboardSize = [self frame].size;
        CGFloat width = clipboardSize.width / numberColumns;
        CGFloat height = clipboardSize.height / numberRows;
        CGSize itemSize = CGSizeMake(width, height);
        while (numberItems != 0)
        {
            CBItemView *itemView = [[CBItemView alloc] initWithContentSize:itemSize];
            [items addObject:itemView];
            [self addSubview:itemView];
            numberItems = numberItems - 1;
        }
        [self setWantsLayer:YES];
    }
    return self;
}

- (NSUInteger)rows
{
    return numberRows;
}

- (NSUInteger)columns
{
    return numberColumns;
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
    return [items objectAtIndex:0];
}

@end
