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
  if([viewSlots count] > index) {
    [[viewSlots objectAtIndex:index] removeFromSuperview];
  }
  [viewSlots insertObject:itemView atIndex:index];
  [clipboardView addSubview:itemView];
}

- (void)drawEmptySlotAtIndex:(NSInteger)index {
  CGRect frame = [[frames objectAtIndex:index] rectValue];
  NSView *slotView = [[NSView alloc] initWithFrame:frame];
  if([viewSlots count] > index) {
    [[viewSlots objectAtIndex:index] removeFromSuperview];
  }
  [viewSlots insertObject:slotView atIndex:index];
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
      [self drawEmptySlotAtIndex:(row*2 + column)];
    }
  }
}

- (NSArray*)allItems {
  return [clipboard items];
}

@end

@implementation CBClipboardController

- (void)setItemQuiet:(CBItem *)item atIndex:(NSInteger)index {
  [clipboard setItem:item atIndex:index];
  [self drawItem:item atIndex:index];
}

- (void)setItem:(CBItem *)item atIndex:(NSInteger)index {
  [self setItemQuiet:item atIndex:index];
  lastChanged = [[NSDate alloc] init];
  if(changeListener) {
    [changeListener didSetItem:item atIndex:index];
  }
}

- (void)addItem:(CBItem *)item {
  [clipboard insertItem:item atIndex:0];
  NSArray* items = [clipboard items];
  for(NSInteger index=0; index<8; index++) {
    id object = [items objectAtIndex:index];
    if([object isEqualTo: [NSNull null]]) {
      [self drawEmptySlotAtIndex:index];
    } else {
      [self drawItem:object atIndex:index];
      if(changeListener) {
        [changeListener didSetItem:object atIndex:index];
      }
    }
  }
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
    viewSlots = [[NSMutableArray alloc] init];
    clipboard = [[CBClipboard alloc] initWithCapacity:(ROWS * COLUMNS)];
    clipboardView = [[CBClipboardView alloc] initWithFrame:aFrame];
    lastChanged = [[NSDate alloc] init];
    [self initializeItemSlots];
    [viewController addSubview:clipboardView];
  }
  return self;
}

- (NSDate*)lastChanged {
  return lastChanged;
}

@end

@implementation CBClipboardController(Delegation)

//CBItemViewDelegate
- (void)itemViewClicked:(CBItemView *)view index:(NSInteger)index {
  NSAttributedString *string = [[clipboard itemAtIndex:index] string];
  NSPasteboard *systemPasteboard = [NSPasteboard generalPasteboard];
  [systemPasteboard clearContents];
  [systemPasteboard writeObjects:[NSArray arrayWithObject:string]];
}

@end