#import "Cloudboard.h"

#define ROWS 4
#define COLUMNS 2
#define PADDING 20

@implementation CBClipboardController(Private)

- (void)drawItem:(CBItem *)item atIndex:(NSInteger)index {
  CGRect frame = [[frames objectAtIndex:index] rectValue];
  CBItemView *itemView = [[CBItemView alloc] initWithFrame:frame index:index style:CBItemViewStyleNote];
  [itemView setContent:[item string]];
  [itemView setDelegate:self];
  if([itemViews count] > index) {
    [[itemViews objectAtIndex:index] removeFromSuperview];
  }
  [itemViews insertObject:itemView atIndex:index];
  [clipboardView addSubview:itemView];
}

- (void)drawSlotAtIndex:(NSInteger)index {
  CGRect frame = [[frames objectAtIndex:index] rectValue];
  NSView *slotView = [[NSView alloc] initWithFrame:frame];
  if([itemViews count] > index) {
    [[itemViews objectAtIndex:index] removeFromSuperview];
  }
  [itemViews insertObject:slotView atIndex:index];
  [clipboardView addSubview:slotView];
}

- (void)initializeItemSlots {
  CGRect mainBounds = [clipboardView bounds];
  CGFloat itemWidth = (mainBounds.size.width - ((COLUMNS + 1) * PADDING)) / COLUMNS;
  CGFloat itemHeight = (mainBounds.size.height - ((ROWS + 1) * PADDING)) / ROWS;
  CGPoint origin = CGPointMake(PADDING, (mainBounds.size.height - itemHeight - PADDING));
  
  for(NSInteger row=0; row<ROWS; row++) {
    for(NSInteger column=0; column<COLUMNS; column++) {
      CGFloat x = origin.x + (column * (itemWidth + PADDING));
      CGFloat y = origin.y - (row * (itemHeight + PADDING));
      CGRect itemFrame = CGRectMake(x, y, itemWidth, itemHeight);
      [frames addObject:[NSValue valueWithRect:itemFrame]];
      [self drawSlotAtIndex:(row*2 + column)];
    }
  }
}

@end

@implementation CBClipboardController

- (void)setItemQuiet:(CBItem *)item atIndex:(NSInteger)index {
  [clipboard setItem:item atIndex:index];
  [self drawItem:item atIndex:index];
}

- (void)setItem:(CBItem *)item atIndex:(NSInteger)index {
  [self setItemQuiet:item atIndex:index];
  if(changeListener) {
    [changeListener insertedItem:item atIndex:index];
  }
}

- (void)addItem:(CBItem *)item {
  [clipboard insertItem:item atIndex:0];
  [self drawItem:item atIndex:0];
}

- (BOOL)clipboardContainsItem:(CBItem *)item {
  return [[clipboard items] containsObject:item];
}

- (void)addChangeListener:(id)object {
  changeListener = object;
}

@end

@implementation CBClipboardController(Overridden)

- (id)initWithFrame:(CGRect)aFrame viewController:(id)viewController {
  self = [super init];
  if (self != nil) {
    frames = [[NSMutableArray alloc] init];
    itemViews = [[NSMutableArray alloc] init];
    clipboard = [[CBClipboard alloc] initWithCapacity:(ROWS * COLUMNS)];
    clipboardView = [[CBClipboardView alloc] initWithFrame:aFrame];
    [self initializeItemSlots];
    [viewController addSubview:clipboardView];
  }
  return self;
}

@end

@implementation CBClipboardController(Delegation)

- (void)itemView:(CBItemView *)view clickedWithEvent:(NSEvent *)event {

}

- (void)itemView:(CBItemView *)view areaClicked:(CBItemViewArea)area withEvent:(NSEvent *)event {
  
}

- (void)itemView:(CBItemView *)view draggedWithEvent:(NSEvent *)event {
  
}

- (void)itemView:(CBItemView *)view didReceiveDropWithObject:(id <NSPasteboardReading>)object {
  
}

@end