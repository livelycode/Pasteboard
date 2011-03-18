#import "Cloudboard.h"

#define PADDING 0

#define BUTTON_PADDING 16
#define BUTTON_HEIGHT 24
#define BUTTON_WIDTH 80

@implementation CBClipboardController(Actions)

- (void)clearClipboardClicked:(id)sender {
  [self clearClipboardSyncing:YES];
}

- (void)showSettingsClicked:(id)sender {
  [windowController showBack];
}

@end

@implementation CBClipboardController(Delegation)
//CBItemViewDelegate
- (void)itemViewClicked:(CBItemView*)view {
  NSInteger index = [itemViewSlots indexOfObject:view];
  NSString *string = [[clipboard itemAtIndex:index] string];
  NSPasteboard *systemPasteboard = [NSPasteboard generalPasteboard];
  [systemPasteboard clearContents];
  [systemPasteboard writeObjects:[NSArray arrayWithObject:string]];
}

//CBPasteViewDelegate
- (void)pasteViewClicked {
  
}
@end

@implementation CBClipboardController

- (id)initWithFrame:(CGRect)aFrame windowController:(CBMainWindowController *)aController {
  self = [super initWithNibName:@"clipboard" bundle:nil];
  if (self != nil) {
    rows = 4;
    columns = 2;
    frames = [[NSMutableArray alloc] init];
    itemViewSlots = [[NSMutableArray alloc] init];
    clipboard = [[CBClipboard alloc] initWithCapacity:rows*columns-1];
    windowController = [aController retain];
    [[self view] setFrame:aFrame];
    [self initializeItemSlots];
    [self drawPasteView];
    [self drawAllItems];
  }
  return self;
}

- (void)setSyncController:(CBSyncController *)controller {
  [syncController release];
  syncController = [controller retain];
}

@end

@implementation CBClipboardController(Private)

- (CGRect)rectForNSValue:(NSValue*)value {
  return [value rectValue];
}

- (void)moveAllItemViewsAnimated {
  [itemViewSlots enumerateObjectsUsingBlock:^(id itemView, NSUInteger index, BOOL *stop) {
    CGRect newFrame = [[frames objectAtIndex:index+1] rectValue];
    [[itemView animator] setFrame:newFrame];
  }];
}

- (void)initializeItemSlots {
  CGRect mainBounds = [[self view] bounds];
  NSUInteger itemWidth = (mainBounds.size.width - ((columns + 1) * PADDING)) / columns;
  NSUInteger itemHeight = (mainBounds.size.height - ((rows + 1) * PADDING)) / rows;
  CGPoint origin = CGPointMake(PADDING, (mainBounds.size.height - itemHeight - PADDING));
  for(NSInteger row=0; row<rows; row++) {
    for(NSInteger column=0; column<columns; column++) {
      NSUInteger x = origin.x + (column * (itemWidth + PADDING));
      NSUInteger y = origin.y - (row * (itemHeight + PADDING));
      CGRect itemFrame = CGRectMake(x, y, itemWidth, itemHeight);
      [frames addObject:[NSValue valueWithRect:itemFrame]];
    }
  }
}

- (void)addItemView:(NSView*)itemView {
  [self.view addSubview: itemView];
}

@end