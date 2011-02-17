#import "Cloudboard.h"

@implementation CBClipboardView

- (void)drawRect:(NSRect)rect
{
    [color set];
    [NSBezierPath fillRect:[self bounds]];
}

- (id)initWithFrame:(CGRect)aFrame
               Rows:(NSUInteger)rowsNumber
            Columns:(NSUInteger)columnsNumber
          itemClass:(Class)itemClass;
{
    self = [super init];
    if (self != nil)
    {
        matrix = [[NSMatrix alloc] initWithFrame:aFrame
                                            mode:NSTrackModeMatrix
                                       cellClass:itemClass
                                    numberOfRows:rowsNumber
                                 numberOfColumns:columnsNumber];
        numberRows = rowsNumber;
        numberColumns = columnsNumber;
        cornerRadius = 0;
        color = [NSColor whiteColor];
        
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
