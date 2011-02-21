#import "Cloudboard.h"

#define LINE_SPACING 39
#define NUMBER_LINES 24
#define BORDER_SPACING 32
#define ROW_SPACING 8

@implementation CBClipboardView

- (id)initWithFrame:(CGRect)aFrame
               Rows:(NSUInteger)numberRows
            Columns:(NSUInteger)numberColumns;
{
    self = [super initWithFrame:aFrame];
    if (self != nil)
    {
        rows = numberRows;
        columns = numberColumns;
        
        NSUInteger numberItems = rows * columns;
        itemViews = [NSMutableArray arrayWithCapacity:numberItems];
        while (numberItems != 0)
        {
            CBItemView *itemView = [[CBItemView alloc] initWithFrame:CGRectZero];
            [itemViews addObject:itemView];
            [itemView setDelegate:self];
            [self addSubview:itemView];
            numberItems = numberItems - 1;
        }
        
        [self setPadding:0];
    }
    return self;
}

- (void)drawRect:(NSRect)rect
{   
    CGRect contentFrame = [self bounds];
    
    [[NSColor whiteColor] setFill];
    [NSBezierPath fillRect:contentFrame];
        
    NSColor *horizontalLineColor = [NSColor colorWithCalibratedWhite:0.8
                                                               alpha:1];
    [horizontalLineColor setStroke];
    NSUInteger numberLines = NUMBER_LINES;
    CGFloat y = (contentFrame.size.height / 2) - (((NUMBER_LINES - 1) * LINE_SPACING) / 2) - 0.5;
    while (numberLines != 0)
    {
        [NSBezierPath strokeLineFromPoint:NSMakePoint(contentFrame.origin.x, y)
                                  toPoint:NSMakePoint(contentFrame.size.width, y)];
        y = y + LINE_SPACING;
        numberLines = numberLines - 1;
    }
    
    NSColor *verticalLineColor = [NSColor colorWithCalibratedRed:1
                                                           green:0.7
                                                            blue:0.7
                                                           alpha:1];
    [verticalLineColor setStroke];
    CGFloat x1 = contentFrame.origin.x + BORDER_SPACING + 0.5;
    CGFloat x2 = contentFrame.origin.x + BORDER_SPACING + ROW_SPACING + 0.5;
    [NSBezierPath strokeLineFromPoint:NSMakePoint(x1, contentFrame.origin.y)
                              toPoint:NSMakePoint(x1, contentFrame.size.height)];
    [NSBezierPath strokeLineFromPoint:NSMakePoint(x2, contentFrame.origin.y)
                              toPoint:NSMakePoint(x2, contentFrame.size.height)];
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

- (void)setDelegate:(id <CBItemViewDelegate>)anObject
{
    delegate = anObject;
}

- (void)setString:(NSString *)aString
   forItemAtIndex:(NSUInteger)anIndex
{
    [[itemViews objectAtIndex:anIndex] setString:aString];
}

- (void)setHidden:(BOOL)isHidden
   forItemAtIndex:(NSUInteger)anIndex
{
    [[itemViews objectAtIndex:anIndex] setHidden:isHidden];
}

@end

@implementation CBClipboardView(Delegation)

- (void)itemViewClicked:(CBItemView *)itemView
{
    NSUInteger index = [itemViews indexOfObject:itemView];
    [delegate didReceiveClickForItemAtIndex:index];
}

- (void)itemViewDismissButtonClicked:(CBItemView *)itemView
{
    NSUInteger index = [itemViews indexOfObject:itemView];
    [delegate didReceiveDismissClickForItemAtIndex:index];
}

@end