#import "Cloudboard.h"

#define LINE_SPACING 39
#define NUMBER_LINES 24
#define BORDER_SPACING 32
#define ROW_SPACING 8

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
        
        NSColor *startingColor = [NSColor colorWithCalibratedWhite:0.9
                                                             alpha:1];
        NSColor *endingColor = [NSColor colorWithCalibratedWhite:1
                                                           alpha:1];
        gradient = [[NSGradient alloc] initWithStartingColor:startingColor
                                                 endingColor:endingColor];
        
        NSUInteger numberItems = rows * columns;
        itemViews = [NSMutableArray arrayWithCapacity:numberItems];
        while (numberItems != 0)
        {
            NSView *itemView = [[itemClass alloc] initWithFrame:CGRectZero];
            [itemViews addObject:itemView];
         //   [self addSubview:itemView];
            numberItems = numberItems - 1;
        }
        
        [self setPadding:0];
    }
    return self;
}

- (void)drawRect:(NSRect)rect
{
    CGRect mainBounds = [self bounds];
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:mainBounds];
    [gradient drawInBezierPath:path
                         angle:90];
    
    NSColor *horizontalLineColor = [NSColor colorWithCalibratedWhite:0.8
                                                     alpha:1];
    [horizontalLineColor setStroke];
    NSUInteger numberLines = NUMBER_LINES;
    CGFloat y = (mainBounds.size.height / 2) - (((NUMBER_LINES - 1) * LINE_SPACING) / 2) - 0.5;
    while (numberLines != 0)
    {
        [NSBezierPath strokeLineFromPoint:NSMakePoint(0, y)
                                  toPoint:NSMakePoint(mainBounds.size.width, y)];
        y = y + LINE_SPACING;
        numberLines = numberLines - 1;
    }
    
    NSColor *verticalLineColor = [NSColor colorWithCalibratedRed:1
                                                           green:0.7
                                                            blue:0.7
                                                           alpha:1];
    [verticalLineColor setStroke];
    CGFloat x1 = BORDER_SPACING + 0.5;
    CGFloat x2 = BORDER_SPACING + ROW_SPACING + 0.5;
    [NSBezierPath strokeLineFromPoint:NSMakePoint(x1, 0)
                              toPoint:NSMakePoint(x1, mainBounds.size.height)];
    [NSBezierPath strokeLineFromPoint:NSMakePoint(x2, 0)
                              toPoint:NSMakePoint(x2, mainBounds.size.height)];
    
                                                  
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
