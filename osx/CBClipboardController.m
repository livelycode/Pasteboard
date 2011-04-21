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
  CBApplicationController* appController = [[NSApplication sharedApplication] delegate];
  CBItem* newItem = [appController currentPasteboardItem];
  if(newItem != nil) {
    [self addItem:newItem syncing:YES];
  }
}
@end

@implementation CBClipboardController

- (id)initWithFrame:(CGRect)aFrame windowController:(CBMainWindowController *)aController {
  self = [super initWithNibName:@"clipboard" bundle:nil];
  if (self != nil) {
    rows = 4;
    columns = 2;
    frame = aFrame;
    frames = [[NSMutableArray alloc] init];
    itemViewSlots = [[NSMutableArray alloc] init];
    clipboard = [[CBClipboard alloc] initWithCapacity:rows*columns-1];
    windowController = [aController retain];
  }
  return self;
}

- (void)awakeFromNib {
  [[self view] setFrame:frame];
  [self initializeItemSlots];
  [self drawPasteView];
  [self drawAllItems];
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
  CGRect mainBounds = [itemsView bounds];
  CGRect itemsBounds = CGRectMake(0, 0, CGRectGetWidth(mainBounds), CGRectGetHeight(mainBounds));
  CGFloat clipboardHeight = CGRectGetHeight(itemsBounds);
  CGFloat clipboardWidth = CGRectGetWidth(itemsBounds);
  NSUInteger itemWidth = clipboardWidth / columns;
  NSUInteger itemHeight = clipboardHeight / rows;
  for(NSInteger row=rows; row>=1; row--) {
    for(NSInteger column=1; column<=columns; column++) {
      NSUInteger x = itemWidth*(column-1);
      NSUInteger y = (row-1)*itemHeight;
      CGRect itemFrame = CGRectMake(x, y, itemWidth, itemHeight);
      [frames addObject:[NSValue valueWithRect:itemFrame]];
    }
  }
}

- (void)addItemView:(NSView*)itemView {
  [itemsView addSubview: itemView];
}

@end