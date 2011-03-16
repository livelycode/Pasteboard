#import "Cloudboard.h"

#define PADDING_TOP 40
#define PADDING_LEFT 20

#define ITEMS 8
#define ROWS_PORTRAIT 4
#define ROWS_LANDSCAPE 2

@implementation CBClipboardController

- (id)initWithDelegate:(id)appController {
  self = [super initWithNibName:@"Clipboard" bundle:nil];
  if (self != nil) {
    if((self.interfaceOrientation == UIInterfaceOrientationPortrait) ||
       (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
      [self setRowsForPortrait];
    } else {
      [self setRowsForLandscape];
    }
    clipboard = [[CBClipboard alloc] initWithCapacity:rows*columns-1];
    frames = [[NSMutableArray alloc] init];
    itemViewSlots = [[NSMutableArray alloc] init];
    delegate = appController;
    [self startSyncing];
  }
  return self;
}

- (void)stopSyncing {
  [syncController release];
  if(popoverController.popoverVisible) {
    [popoverController dismissPopoverAnimated:NO]; 
    [popoverController release];
  }
}

- (void)startSyncing {
  syncController = [[CBSyncController alloc] initWithClipboardController:self];
}

- (void)dealloc {
  [clipboard release];
  [syncController release];
  [itemViewSlots release];
  [super dealloc];
}

@end

@implementation CBClipboardController(Overriden)

- (void)viewDidLoad {
  [self preparePopoverView];
  [self initializeItemViewFrames];
  [self drawPasteButton];
  [self drawAllItems];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

/*- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  if((toInterfaceOrientation == UIInterfaceOrientationPortrait) || (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
    [self setRowsForPortrait];
    NSLog(@"portrait");
  } else {
    [self setRowsForLandscape];
    NSLog(@"landscape");
  }
  CGRect newFrame = CGRectMake(0, 0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame));
  [self.view setFrame:newFrame];
  [frames removeAllObjects];
  [self initializeItemViewFrames];
  [UIView animateWithDuration:0.5 animations:^(void) {
    [self moveAllItemViews];
    [pasteButton setFrame:[[frames objectAtIndex:0] CGRectValue]];
  }];
}*/
@end

@implementation CBClipboardController(Delegation)
//UIGestureRecognizerDelegate
- (void)handleTapFromPasteView:(CBPasteView*)view {
  CBItem* newItem = [delegate currentPasteboardItem];
  if(newItem != nil) {
    [self addItem:newItem syncing:YES];
  }
}

- (void)handleTapFromItemView:(CBItemView*)itemView {
  NSInteger index = [itemViewSlots indexOfObject:itemView];
  NSString *string = [[clipboard itemAtIndex:index] string];
  NSLog(@"%@", string);
  UIPasteboard *systemPasteboard = [UIPasteboard generalPasteboard];
  [systemPasteboard setValue: string forPasteboardType:(NSString*)kUTTypeUTF8PlainText];
}

//UIToolbarDelegate
- (void)devicesButtonTapped:(id)event {
  if(popoverController.popoverVisible) {
    [popoverController dismissPopoverAnimated:NO]; 
  } else {
    [popoverController presentPopoverFromBarButtonItem:devicesButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];
  }
}

- (void)clearAllButtonTapped:(id)event {
  [self clearClipboardSyncing:YES];
}
@end

@implementation CBClipboardController(Private)

- (CGRect)rectForNSValue:(NSValue*)value {
  return [value CGRectValue];
}

- (CGRect)clipboardFrame {
  CGRect mainFrame = [[UIScreen mainScreen] bounds];
  CGRect frame = CGRectOffset(mainFrame, 0, 20);
  return frame;
}

- (void)preparePopoverView {
  CBDevicesViewController* devicesViewController = [[CBDevicesViewController alloc] initWithClipboard:self syncController:syncController];
  popoverController = [[UIPopoverController alloc] initWithContentViewController:devicesViewController];
  popoverController.popoverContentSize = CGSizeMake(300, 300);
}

- (void)drawPasteButton {
  CGRect frame = [[frames objectAtIndex:0] CGRectValue];
  pasteButton = [[CBPasteView alloc] initWithFrame:CGRectInset(frame, 10, 10) delegate:self];
  [self.view addSubview:pasteButton];
}

- (void)setRowsForPortrait {
  rows = ROWS_PORTRAIT;
  columns = ITEMS/rows;
}

- (void)setRowsForLandscape {
  rows = ROWS_LANDSCAPE;
  columns = ITEMS/rows;
}

- (void)moveAllItemViewsAnimated {
  [UIView animateWithDuration:0.5 animations:^(void) {
    [self moveAllItemViews];
  }];
}

- (void)initializeItemViewFrames {	
  CGFloat paddingTop = PADDING_TOP;
  CGFloat paddingLeft = PADDING_LEFT;
  CGRect mainBounds = [clipboardView bounds];
  CGRect itemsBounds = CGRectMake(paddingLeft, paddingTop, CGRectGetWidth(mainBounds)-2*paddingLeft, CGRectGetHeight(mainBounds)-2*paddingTop);
  CGFloat clipboardHeight = CGRectGetHeight(itemsBounds);
  CGFloat clipboardWidth = CGRectGetWidth(itemsBounds);
  CGFloat itemWidth = clipboardWidth / columns;
  CGFloat itemHeight = clipboardHeight / rows;
  for(NSInteger row=1; row<=rows; row++) {
    for(NSInteger column=1; column<=columns; column++) {
      CGFloat x = paddingLeft + itemWidth*(column-1);
      CGFloat y = paddingTop +(row-1)*itemHeight;
      CGRect itemFrame = CGRectMake(x, y, itemWidth, itemHeight);
      [frames addObject:[NSValue valueWithCGRect:itemFrame]];
    }
  }
}

-(void)addItemView:(CBItemView *)itemView {
  [self.view addSubview:itemView];
}

@end