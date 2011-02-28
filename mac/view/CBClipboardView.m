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
            Columns:(NSUInteger)numberColumns {
    self = [super initWithFrame:aFrame];
    if (self != nil) {
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
      while (numberItems != 0) {
          CGFloat x = origin.x + (currentColumn * (itemWidth + thePadding));
          CGFloat y = origin.y - (currentRow * (itemHeight + thePadding));
          CGRect itemFrame = CGRectMake(x, y, itemWidth, itemHeight);
          
          currentColumn = currentColumn + 1;
          if (currentColumn >= columns) {
              currentColumn = 0;
              currentRow = currentRow + 1;
          }
          
          CBItemView *itemView = [[CBItemView alloc] initWithFrame:itemFrame];
          [itemView setNoteVisible:NO];
          [itemView setDelegate:self];
          [itemViews addObject:itemView];
          [self addSubview:itemView];
          numberItems = numberItems - 1;
    }
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
    
}

- (NSUInteger)itemViews
{
    return [itemViews count];
}

- (BOOL)itemAtIndexIsVisible:(NSUInteger)anIndex
{
    return [[itemViews objectAtIndex:anIndex] isNoteVisible];
}

- (NSAttributedString *)stringForItemAtIndex:(NSUInteger)anIndex
{
    return [[itemViews objectAtIndex:anIndex] text];
}

- (void)setDelegate:(id <CBItemViewDelegate>)anObject
{
    delegate = anObject;
}

- (void)setString:(NSAttributedString *)aString
   forItemAtIndex:(NSUInteger)anIndex
{
    [[itemViews objectAtIndex:anIndex] setText:aString];
}

- (void)setAllViewItemsInvisible
{
    for (CBItemView *itemView in itemViews)
    {
        [itemView setNoteVisible:NO];
    }
}

- (void)setVisible:(BOOL)isVisible
   forItemAtIndex:(NSUInteger)anIndex
{
    [[itemViews objectAtIndex:anIndex] setNoteVisible:isVisible];
}

- (NSUInteger)invisibleItemsUpToIndex:(NSUInteger)anIndex
{
    NSMutableArray *itemViewsCopy = [NSMutableArray arrayWithArray:itemViews];
    NSUInteger tailLength = [itemViewsCopy count] - anIndex;
    NSRange range = NSMakeRange(anIndex, tailLength);
    [itemViewsCopy removeObjectsInRange:range];
    NSUInteger hiddenItemViews = 0;
    for (CBItemView *itemView in itemViewsCopy)
    {
        if ([itemView isNoteVisible] == NO)
        {
            hiddenItemViews = hiddenItemViews + 1;
        }
    }
    return hiddenItemViews;
}

- (void)startDragOperationWithEvent:(NSEvent *)anEvent
                             object:(id <NSPasteboardWriting>)anObject
                     forItemAtIndex:(NSUInteger)anIndex;
{
    CBItemView *itemView = [itemViews objectAtIndex:anIndex];
    [itemView startDragWithEvent:anEvent
                          object:anObject];
}

@end

@implementation CBClipboardView(Delegation)

- (void)itemView:(CBItemView *)itemView
clickedWithEvent:(NSEvent *)anEvent;
{
    NSUInteger index = [itemViews indexOfObject:itemView];
    [delegate clipboardView:self
            didReceiveClick:anEvent
             forItemAtIndex:index];
}

- (void)itemView:(CBItemView *)itemView
   buttonClicked:(NSString *)aName
       withEvent:(NSEvent *)anEvent
{
    NSUInteger index = [itemViews indexOfObject:itemView];
    [delegate clipboardView:self
            didReceiveClick:anEvent
          forButtonWithName:nil
                    atIndex:index];
}

- (void)itemView:(CBItemView *)itemView
draggedWithEvent:(NSEvent *)anEvent
{
    NSUInteger index = [itemViews indexOfObject:itemView];
    [delegate clipboardView:self
         didReceiveDragging:anEvent
             forItemAtIndex:index];
}

- (void)itemView:(CBItemView *)itemView
  dropWithObject:(id <NSPasteboardReading>)anObject;
{
    NSUInteger index = [itemViews indexOfObject:itemView];
    [delegate clipboardView:self
             didReceiveDrop:anObject
            fromItemAtIndex:index];
}

@end