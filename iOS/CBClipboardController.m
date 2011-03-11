#import "Cloudboard.h"

#define ROWS 4
#define COLUMNS 2
#define PADDING_TOP 40
#define PADDING_LEFT 20

@implementation CBClipboardController(Private)

- (void)drawItem:(CBItem*)item {
  CGRect frame = [[frames objectAtIndex:0] CGRectValue];
  CBItemView *newItemView = [[CBItemView alloc] initWithFrame:frame content:[item string] delegate:self];
  [itemViewSlots insertObject:newItemView atIndex:0];
  [[self view] addSubview:newItemView];
  //remove last itemView if necessary
  while([itemViewSlots count] > (ROWS*COLUMNS-1)) {
    CBItemView* lastView = [itemViewSlots objectAtIndex:([itemViewSlots count]-1)];
    [itemViewSlots removeLastObject]; 
    [lastView removeFromSuperview];
  }
  //move all existing itemViews
  [itemViewSlots enumerateObjectsUsingBlock:^(id itemView, NSUInteger index, BOOL *stop) {
    CGRect newFrame = [[frames objectAtIndex:index+1] CGRectValue];
    [itemView setFrame:newFrame];
  }];
}

- (void)drawToolbar {
  toolbar = [[UIToolbar alloc] init];
  [toolbar sizeToFit];
  CGFloat toolbarHeight = CGRectGetHeight([toolbar frame]);
  CGRect toolbarRect = CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), toolbarHeight);
  [toolbar setFrame:toolbarRect];
  devicesButton = [[UIBarButtonItem alloc] initWithTitle:@"Manage Devices" style:UIBarButtonItemStyleBordered target:self action:@selector(devicesButtonTapped:)];
  
  UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  
  UIBarButtonItem* removeAllButton = [[UIBarButtonItem alloc] initWithTitle:@"Remove All" style:UIBarButtonItemStyleBordered target:self action:@selector(clearAllButtonTapped:)];
  [toolbar setItems:[[NSArray alloc] initWithObjects:devicesButton, flexibleSpace, removeAllButton, nil] animated:NO];
  [self.view addSubview:toolbar];
}

- (void)preparePopoverView {
  CBDevicesViewController* devicesViewController = [[CBDevicesViewController alloc] initWithClipboard:self syncController:syncController];
  popoverController = [[UIPopoverController alloc] initWithContentViewController:devicesViewController];
  popoverController.popoverContentSize = CGSizeMake(300, 300);
}

- (void)drawPasteButton {
  CGRect frame = [[frames objectAtIndex:0] CGRectValue];
  UIButton* pasteView = [[UIButton alloc] initWithFrame:CGRectInset(frame, 10, 10)];
  [pasteView setTitle:@"Paste" forState:UIControlStateNormal];
  pasteView.layer.borderWidth = 1;
  UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(handleTapFromPasteView:)];
  [pasteView addGestureRecognizer:recognizer];
  [self.view addSubview:pasteView];
}

- (void)initializeItemViewFrames {
  NSInteger rows = ROWS;
  NSInteger columns = COLUMNS;
  CGFloat paddingTop = PADDING_TOP + CGRectGetHeight(toolbar.frame);
  CGFloat paddingLeft = PADDING_LEFT;
  CGRect mainBounds = [self.view bounds];
  CGFloat clipboardHeight = CGRectGetHeight(mainBounds);
  CGFloat clipboardWidth = CGRectGetWidth(mainBounds);
  CGFloat itemWidth = (clipboardWidth-2*paddingLeft) / columns;
  CGFloat itemHeight = (clipboardHeight-2*paddingTop) / rows;  
  for(NSInteger row=1; row<=rows; row++) {
    for(NSInteger column=1; column<=columns; column++) {
      CGFloat x = paddingLeft + itemWidth*(column-1);
      CGFloat y = paddingTop +(row-1)*itemHeight;
      CGRect itemFrame = CGRectMake(x, y, itemWidth, itemHeight);
      [frames addObject:[NSValue valueWithCGRect:itemFrame]];
    }
  }
}

@end

@implementation CBClipboardController

- (id)initWithDelegate:(id)appController {
  self = [super init];
  if (self != nil) {
    clipboard = [[CBClipboard alloc] initWithCapacity:ROWS*COLUMNS-1];
    frames = [[NSMutableArray alloc] init];
    itemViewSlots = [[NSMutableArray alloc] init];
    lastChanged = [[NSDate alloc] init];
    delegate = appController;
    [self startSyncing];
    [self view];
  }
  return self;
}

- (void)addItem:(CBItem *)item syncing:(BOOL)sync {
  [clipboard addItem:item];
  [clipboard persist];
  [self drawItem:item];
  if(sync) {
    if(syncController) {
      [syncController didAddItem:item];
    } 
  }
}

- (BOOL)clipboardContainsItem:(CBItem *)anItem {
  return [[clipboard items] containsObject:anItem];
}

- (void)addSyncController:(id)anObject {
  syncController = [anObject retain];
}

- (NSDate*)lastChanged {
  return lastChanged;
}

- (NSArray*)allItems {
  return [clipboard items];
}

- (CBSyncController*)syncController {
  return syncController;
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
  [self preparePopoverView];
}
		
- (void)persistClipboard {
  [clipboard persist];
}

- (void)clearClipboardSyncing:(BOOL)sync {
  for (CBItemView* view in itemViewSlots) {
    [view removeFromSuperview];
  }
  [clipboard clear];
  if(sync) {
    [syncController didResetItems];
  }
  [clipboard persist];
}

- (void)dealloc {
  [clipboard release];
  [syncController release];
  [itemViewSlots release];
  [super dealloc];
}

@end

@implementation CBClipboardController(Overriden)

- (void)loadView {
  CGRect mainFrame = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = CGRectGetHeight(mainFrame);
  CGFloat screenWidth = CGRectGetWidth(mainFrame);
  CGRect frame = CGRectMake(0, 0, screenWidth, screenHeight);
  UIView* clipboardView = [[UIView alloc] initWithFrame:frame];
  [clipboardView setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
  [self setView:clipboardView];
  [delegate addSubview:clipboardView];
  [self drawToolbar];
  [self preparePopoverView];
  [self initializeItemViewFrames];
  [self drawPasteButton];
  for(id item in [clipboard items]) {
    [self drawItem:item];
  }
}

- (void)viewDidLoad {

}
@end

@implementation CBClipboardController(Delegation)
//UIGestureRecognizerDelegate
- (void)handleTapFromPasteView:(UITapGestureRecognizer *)recognizer {
  CBItem* newItem = [delegate currentPasteboardItem];
  if(newItem != nil) {
    [self addItem:newItem syncing:YES];
  }
}

- (void)handleTapFromItemView:(CBItemView*)itemView {
  NSInteger index = [itemViewSlots indexOfObject:itemView];
  NSString *string = [[clipboard itemAtIndex:index] string];
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