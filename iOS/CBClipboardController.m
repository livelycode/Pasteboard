#import "Cloudboard.h"

#define PADDING_TOP 40
#define PADDING_LEFT 20

@implementation CBClipboardController(Private)

- (CGRect)rectForNSValue:(NSValue*)value {
  return [value CGRectValue];
}

- (void)drawToolbar {
  toolbar = [[UIToolbar alloc] init];
  [toolbar sizeToFit];
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
  CBPasteView* pasteView = [[CBPasteView alloc] initWithFrame:CGRectInset(frame, 10, 10) delegate:self];
  [self.view addSubview:pasteView];
}

- (void)initializeItemViewFrames {	
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
    rows = 4;
    columns = 2;
    clipboard = [[CBClipboard alloc] initWithCapacity:rows*columns-1];
    frames = [[NSMutableArray alloc] init];
    itemViewSlots = [[NSMutableArray alloc] init];
    delegate = appController;
    [self startSyncing];
    [self view];
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
  [self preparePopoverView];
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
  CGRect frame = CGRectOffset(mainFrame, 0, 20);
  UIView* clipboardView = [[UIView alloc] initWithFrame:frame];
  [clipboardView setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
  [self setView:clipboardView];
  [delegate addSubview:clipboardView];
  [self drawToolbar];
  [self preparePopoverView];
  [self initializeItemViewFrames];
  [self drawPasteButton];
  [self drawAllItems];
}

- (void)viewDidLoad {

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  if((toInterfaceOrientation == UIInterfaceOrientationPortrait) || (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
    columns = 2;
    rows = 4;
    [self initializeItemViewFrames];
    [self drawAllItems];
    NSLog(@"portrait");
  } else {
    columns = 4;
    rows = 2;
    [self initializeItemViewFrames];
    [self drawAllItems];
    NSLog(@"landscape");
  }
}
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