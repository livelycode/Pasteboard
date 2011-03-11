#import "Cloudboard.h"

#define ROWS 4
#define COLUMNS 2
#define PADDING 0

#define BUTTON_PADDING 16
#define BUTTON_HEIGHT 24
#define BUTTON_WIDTH 80

@implementation CBClipboardController(Private)

- (void)drawItem:(CBItem*)item {
  CGRect frame = [[frames objectAtIndex:0] rectValue];
  CBItemView *newItemView = [[CBItemView alloc] initWithFrame:frame index:0 content:[item string] delegate:self];
  [itemViewSlots insertObject:newItemView atIndex:0];
  [[self view] addSubview:newItemView];
  //remove last itemView if necessary
  while([itemViewSlots count] > (ROWS*COLUMNS-1)) {
    CBItemView* lastView = [itemViewSlots objectAtIndex:([itemViewSlots count]-1)];
    [itemViewSlots removeLastObject];
    [lastView removeFromSuperview];
  }
  //move all existing itemViews
  [itemViewSlots enumerateObjectsUsingBlock:^(CBItemView* itemView, NSUInteger index, BOOL *stop) {
    CGRect newFrame = [[frames objectAtIndex:index+1] rectValue];
    [itemView setFrame:newFrame];
  }];
}

- (void)drawPasteView {
  CGRect frame = [[frames objectAtIndex:0] rectValue];
  NSView *pasteView = [[CBPasteView alloc] initWithFrame:frame delegate:self];
  [[self view] addSubview:pasteView];
}

- (void)initializeItemSlots {
  CGRect mainBounds = [[self view] bounds];
  NSUInteger itemWidth = (mainBounds.size.width - ((COLUMNS + 1) * PADDING)) / COLUMNS;
  NSUInteger itemHeight = (mainBounds.size.height - ((ROWS + 1) * PADDING)) / ROWS;
  CGPoint origin = CGPointMake(PADDING, (mainBounds.size.height - itemHeight - PADDING));
  for(NSInteger row=0; row<ROWS; row++) {
    for(NSInteger column=0; column<COLUMNS; column++) {
      NSUInteger x = origin.x + (column * (itemWidth + PADDING));
      NSUInteger y = origin.y - (row * (itemHeight + PADDING));
      CGRect itemFrame = CGRectMake(x, y, itemWidth, itemHeight);
      [frames addObject:[NSValue valueWithRect:itemFrame]];
    }
  }
}

@end

@implementation CBClipboardController(Actions)

- (void)clearClipboard:(id)sender {
  [self clearClipboard];
}

- (void)showSettings:(id)sender {
  [windowController showBack];
}

@end

@implementation CBClipboardController(Delegation)
//CBItemViewDelegate
- (void)itemViewClicked:(CBItemView*)view index:(NSInteger)index {
  NSString *string = [[clipboard itemAtIndex:index] string];
  NSPasteboard *systemPasteboard = [NSPasteboard generalPasteboard];
  [systemPasteboard clearContents];
  [systemPasteboard writeObjects:[NSArray arrayWithObject:string]];
}

//CBPasteViewDelegate
- (void)pasteViewClicked:(CBPasteView*)view index:(NSInteger)index {
  
}
@end

@implementation CBClipboardController

- (id)initWithFrame:(CGRect)aFrame {
  self = [super initWithNibName:@"clipboard" bundle:nil];
  if (self != nil) {
    frames = [[NSMutableArray alloc] init];
    itemViewSlots = [[NSMutableArray alloc] init];
    clipboard = [[CBClipboard alloc] initWithCapacity:ROWS*COLUMNS-1];
    lastChanged = [[NSDate alloc] init];
    [[self view] setFrame:aFrame];
    [self initializeItemSlots];
    [self drawPasteView];
    for(id item in [clipboard items]) {
      [self drawItem:item];
    }
  }
  return self;
}

- (void)setSyncController:(CBSyncController *)controller {
  syncController = controller;
}

- (void)setWindowController:(CBMainWindowController *)aController {
  windowController = aController;
}

- (void)addItem:(CBItem *)item syncing:(BOOL)sync {
  [clipboard addItem:item];
  [clipboard persist];
  [self drawItem:(CBItem*)item];
  if(sync) {
    if(syncController) {
      [syncController didAddItem:item];
    }
  }
}

- (BOOL)clipboardContainsItem:(CBItem *)item {
  return [[clipboard items] containsObject:item];
}

- (CBSyncController*)syncController {
  return syncController;
}

- (NSDate*)lastChanged {
  return lastChanged;
}

- (NSArray*)allItems {
  return [clipboard items];
}

- (void)persistClipboard {
  [clipboard persist];
}

- (void)clearClipboard {
  for (CBItemView* view in itemViewSlots) {
    [view removeFromSuperview];
  }
  [clipboard clear];
  [clipboard persist];
}
@end