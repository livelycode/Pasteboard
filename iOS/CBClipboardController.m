#import "Cloudboard.h"

#define ROWS 4
#define COLUMNS 2
#define PADDING_TOP 40
#define PADDING_LEFT 20

@implementation CBClipboardController(Private)

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
  
  devicesViewController = [[CBDevicesViewController alloc] initWithClipboard:self syncController:syncController];
  popoverController = [[UIPopoverController alloc] initWithContentViewController:devicesViewController];
  popoverController.popoverContentSize = CGSizeMake(300, 300);
}

- (void)drawItem:(CBItem *)item atViewIndex:(NSInteger)index {
  CGRect frame = [[frames objectAtIndex:index] CGRectValue];
  CBItemView *itemView = [[CBItemView alloc] initWithFrame:frame index:index-1 content:[item string] delegate:self];
  [self removeViewAtViewIndex:index];
  if([viewSlots count] > index) {
    [viewSlots replaceObjectAtIndex:index withObject:itemView];
  } else {
    [viewSlots addObject:itemView];
  }
  [self.view addSubview:itemView];
}

- (void)drawPasteButton {
  CGRect frame = [[frames objectAtIndex:0] CGRectValue];
  UIButton* pasteView = [[UIButton alloc] initWithFrame:CGRectInset(frame, 10, 10)];
  [pasteView setTitle:@"Paste" forState:UIControlStateNormal];
  pasteView.layer.borderWidth = 1;
  [self removeViewAtViewIndex:0];
  UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(handleTapFromPasteView:)];
  [pasteView addGestureRecognizer:recognizer];
  if([viewSlots count] > 0) {
    [viewSlots replaceObjectAtIndex:0 withObject:pasteView];
  } else {
    [viewSlots addObject:pasteView];
  }
  [self.view addSubview:pasteView];
}

- (void)removeViewAtViewIndex:(NSInteger)index {
  if([viewSlots count] > index) {
    [[viewSlots objectAtIndex:index] removeFromSuperview];
  }
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
    viewSlots = [[NSMutableArray alloc] init];
    lastChanged = [[NSDate alloc] init];
    delegate = appController;
    syncController = [[CBSyncController alloc] initWithClipboardController:self];
    [self view];
  }
  return self;
}

- (void)setItem:(CBItem *)item atIndex:(NSInteger)index syncing:(BOOL)sync {
  [clipboard setItem:item atIndex:index];
  if ([item isEqual:[NSNull null]]) {
    [self removeViewAtViewIndex:index+1];
  } else {
    [self drawItem:item atViewIndex:index+1];
  }
  if(sync) {
    [syncController didSetItem:item atIndex:index];
  }
}

- (void)addItem:(CBItem *)item syncing:(BOOL)sync {
  [clipboard addItem:item];
  NSArray* items = [clipboard items];
  for(NSInteger index=0; index<(ROWS*COLUMNS-1); index++) {
    id object = [items objectAtIndex:index];
    if([object isEqual: [NSNull null]]) {
      [self removeViewAtViewIndex:index+1];
    } else {
      [self drawItem:object atViewIndex:index+1];
    }
  }
  if(sync) {
    [syncController didAddItem:item];
  }
}

- (BOOL)clipboardContainsItem:(CBItem *)anItem
{
  return [[clipboard items] containsObject:anItem];
}

- (void)addSyncController:(id)anObject
{
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

- (void)dealloc {
  [clipboard release];
  [syncController release];
  [viewSlots release];
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
  [self initializeItemViewFrames];
  [self drawPasteButton];
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

- (void)handleTapFromItemView:(CBItemView*)itemView index:(NSInteger)index {
  NSString *string = [[[clipboard itemAtIndex:index] string] string];
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
  for (int i=0; i < (ROWS * COLUMNS-1); i++) {
    [self setItem:[NSNull null] atIndex:i syncing:YES];
  }
}
@end