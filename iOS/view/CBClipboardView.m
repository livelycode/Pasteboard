#import "Cloudboard.h"

#define LINE_SPACING 39
#define NUMBER_LINES 24
#define BORDER_SPACING 32
#define ROW_SPACING 8

@implementation CBClipboardView

- (id)init
{
    return [self initWithFrame:CGRectZero
                       padding:0
                          Rows:0
                       Columns:0];
}

- (id)initWithFrame:(CGRect)aFrame
            padding:(CGFloat)thePadding
               Rows:(NSUInteger)numberRows
            Columns:(NSUInteger)numberColumns
{
    self = [super initWithFrame:aFrame];
    if (self != nil)
    {
        rows = numberRows;
        columns = numberColumns;
        
        CGRect mainBounds = [self bounds];
        CGFloat itemWidth = (mainBounds.size.width - ((columns + 1) * thePadding)) / columns;
        CGFloat itemHeight = (mainBounds.size.height - ((rows + 1) * thePadding)) / rows;
        
        CGPoint origin = CGPointMake(thePadding, (mainBounds.size.height - itemHeight - thePadding));
        NSUInteger currentRow = 0;
        NSUInteger currentColumn = 0;
        
        NSUInteger numberItems = rows * columns;
        itemViews = [NSMutableArray arrayWithCapacity:numberItems];
        while (numberItems != 0)
        {
            CGFloat x = origin.x + (currentColumn * (itemWidth + thePadding));
            CGFloat y = origin.y - (currentRow * (itemHeight + thePadding));
            CGRect itemFrame = CGRectMake(x, y, itemWidth, itemHeight);
            
            currentColumn = currentColumn + 1;
            if (currentColumn >= columns)
            {
                currentColumn = 0;
                currentRow = currentRow + 1;
            }
            
            /*CBItemView *itemView = [[CBItemView alloc] initWithFrame:itemFrame];
            [itemView setNoteVisible:NO];
            [itemView setDelegate:self];
            [itemViews addObject:itemView];
            [self addSubview:itemView];*/
            numberItems = numberItems - 1;
        }
    }
    return self;
}

- (void)setDelegate:(id <CBItemViewDelegate>)anObject
{
  delegate = [anObject retain];
}

@end