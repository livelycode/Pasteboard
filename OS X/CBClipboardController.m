#import "Cloudboard.h"

#define ROWS 4
#define COLUMNS 2
#define PADDING 20

@implementation CBClipboardController(Private)

- (void)removeItemViewAtViewIndex:(NSInteger)index {
  if([viewSlots count] > index) {
    [[viewSlots objectAtIndex:index] removeFromSuperview];
  }
}

- (void)drawItem:(CBItem *)item atViewIndex:(NSInteger)index {
  CGRect frame = [[frames objectAtIndex:index] rectValue];
  CBItemView *itemView = [[CBItemView alloc] initWithFrame:frame index:index-1 content:[item string] delegate:self];
  [self removeItemViewAtViewIndex:index];
  if([viewSlots count] > index) {
    [viewSlots replaceObjectAtIndex:index withObject:itemView];
  } else {
    [viewSlots addObject:itemView];
  }
  [clipboardView addSubview:itemView];
}

- (void)drawPasteView {
  CGRect frame = [[frames objectAtIndex:0] rectValue];
  NSView *pasteView = [[CBPasteView alloc] initWithFrame:frame index:0 delegate:self];
  if([viewSlots count] > 0) {
    [viewSlots replaceObjectAtIndex:0 withObject:pasteView];
  } else {
    [viewSlots addObject:pasteView];
  }
  [clipboardView addSubview:pasteView];
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
    }
  }
}

- (NSArray*)allItems {
  return [clipboard items];
}
@end

@implementation CBClipboardController

- (id)initWithFrame:(CGRect)aFrame viewController:(id)viewController {
  self = [super init];
  if (self != nil) {
    frames = [[NSMutableArray alloc] init];
    viewSlots = [[NSMutableArray alloc] init];
    clipboard = [[CBClipboard alloc] initWithCapacity:(ROWS * COLUMNS)];
    clipboardView = [[CBClipboardView alloc] initWithFrame:aFrame];
    lastChanged = [[NSDate alloc] init];
    [self initializeItemSlots];
    [self drawPasteView];
    [viewController addSubview:clipboardView];
  }
  return self;
}

- (void)setItemQuiet:(CBItem *)item atIndex:(NSInteger)index {
  [clipboard setItem:item atIndex:index];
  [self drawItem:item atViewIndex:index];
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
  for(NSInteger index=0; index<(ROWS*COLUMNS-1); index++) {
    id object = [items objectAtIndex:index];
    if([object isEqualTo: [NSNull null]]) {
      [self removeItemViewAtViewIndex:index+1];
    } else {
      [self drawItem:object atViewIndex:index+1];
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

- (NSDate*)lastChanged {
  return lastChanged;
}

- (NSArray*)allItems {
  return [clipboard items];
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

//CBPasteViewDelegate
- (void)pasteViewClicked:(CBItemView *)view index:(NSInteger)index {
  
}
@end