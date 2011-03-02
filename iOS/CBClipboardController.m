#import "Cloudboard.h"

@implementation CBClipboardController(Private)

- (void)initializeClipboardViewWithFrame:(CGRect)aFrame {
  clipboardView = [[UIView alloc] initWithFrame:aFrame];
  [clipboardView setBackgroundColor:[UIColor lightGrayColor]];
  [clipboardView setNeedsDisplay];
}

- (void)initializeItemViews {
  NSInteger rows = 4;
  NSInteger columns = 2;
  NSInteger padding = 20;
  
  CGRect mainBounds = [clipboardView bounds];
  CGFloat itemWidth = (mainBounds.size.width - ((columns + 1) * padding)) / columns;
  CGFloat itemHeight = (mainBounds.size.height - ((rows + 1) * padding)) / rows;
  CGPoint origin = CGPointMake(padding, (mainBounds.size.height - itemHeight - padding));
  
  itemViews = [[NSMutableArray alloc] init];
  for(NSInteger row=0; row<rows; row++) {
    NSMutableArray* rowArray = [[NSMutableArray alloc] init];
    [itemViews insertObject:rowArray atIndex:row];
    for(NSInteger column=0; column<columns; column++) {
      CGFloat x = origin.x + (column * (itemWidth + padding));
      CGFloat y = origin.y - (row * (itemHeight + padding));
      CGRect itemFrame = CGRectMake(x, y, itemWidth, itemHeight);
      CBItemView *itemView = [[CBItemView alloc] initWithFrame:itemFrame];
      [itemView setDelegate:self];
      [clipboardView addSubview:itemView];
      [rowArray insertObject:itemView atIndex:column];
    }
  }
}

@end

@implementation CBClipboardController

- (id)initWithFrame:(CGRect)aFrame viewController:(id)viewController {
  self = [super init];
  if (self != nil)
  {
    clipboard = [[CBClipboard alloc] initWithCapacity:8];
    [self initializeClipboardViewWithFrame: aFrame];
    [self initializeItemViews];
    [viewController addSubview:clipboardView];
  }
  return self;
}

- (void)insertItem:(CBItem *)newItem atIndex:(NSInteger)anIndex {
  [clipboard insertItem:newItem atIndex:anIndex];
  NSAttributedString *string = [newItem string];
  
  if (changeListener != nil)
  {
    [changeListener insertedItem:newItem atIndex:anIndex];
  }
}

- (BOOL)clipboardContainsItem:(CBItem *)anItem
{
  return [[clipboard items] containsObject:anItem];
}

- (void)addChangeListener:(id)anObject
{
  changeListener = [anObject retain];
}

- (void)dealloc {
  [clipboard release];
  [clipboardView release];
  [changeListener release];
  [itemViews release];
  [super dealloc];
}

@end

@implementation CBClipboardController(Delegation)

@end