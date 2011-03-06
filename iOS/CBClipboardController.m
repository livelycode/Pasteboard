#import "Cloudboard.h"

@implementation CBClipboardController(Private)

- (void)drawItem:(CBItem*)item atIndex:(NSInteger)index {
  if([viewSlots count] > index) {
    UIView* oldView = [viewSlots objectAtIndex:index];
    oldView.hidden = YES;
    [oldView removeFromSuperview];
    [oldView setNeedsDisplay];
  }
  CGRect frame = [[frames objectAtIndex:index] CGRectValue];
  CBItemView *itemView = [[CBItemView alloc] initWithFrame:frame index: index content:[item string] delegate:self];
  [viewSlots replaceObjectAtIndex:index withObject:itemView];
  [clipboardView addSubview:itemView];
}

- (void)drawPasteButtonAtIndex:(NSInteger)index {
  NSLog(@"draw empty view at: %i", index);
  CGRect frame = [[frames objectAtIndex:index] CGRectValue];
  UIButton* pasteButton = [[UIButton alloc] initWithFrame:frame];
  [pasteButton setTitle:@"Paste" forState:UIControlStateNormal];
  pasteButton.layer.borderWidth = 1;
  if([viewSlots count] > index) {
    [[viewSlots objectAtIndex:index] removeFromSuperview];
  }
  [viewSlots replaceObjectAtIndex:index withObject:pasteButton];
  [clipboardView addSubview:pasteButton];
}

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
  
  for(NSInteger row=0; row<rows; row++) {
    for(NSInteger column=0; column<columns; column++) {
      CGFloat x = origin.x + (column * (itemWidth + padding));
      CGFloat y = origin.y - (row * (itemHeight + padding));
      CGRect itemFrame = CGRectMake(x, y, itemWidth, itemHeight);
      [frames addObject:[NSValue valueWithCGRect:itemFrame]];
      [self drawPasteButtonAtIndex:(row*2 + column)];
    }
  }
}

@end

@implementation CBClipboardController

- (id)initWithFrame:(CGRect)aFrame viewController:(id)viewController {
  self = [super init];
  if (self != nil) {
    clipboard = [[CBClipboard alloc] initWithCapacity:8];
    frames = [[NSMutableArray alloc] init];
    viewSlots = [[NSMutableArray alloc] init];
    lastChanged = [[NSDate alloc] init];
    [self initializeClipboardViewWithFrame: aFrame];
    [self initializeItemViews];
    [viewController addSubview:clipboardView];
  }
  return self;
}

- (void)setItemQuiet:(CBItem *)newItem atIndex:(NSInteger)anIndex {
  [clipboard setItem:newItem atIndex:anIndex];
  [self drawItem:newItem atIndex:anIndex];
}

- (void)setItem:(CBItem *)newItem atIndex:(NSInteger)anIndex {
  [self setItemQuiet:newItem atIndex:anIndex];
  lastChanged = [[NSDate alloc] init];
  if (changeListener != nil) {
    [changeListener didSetItem:newItem atIndex:anIndex];
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

- (NSDate*)lastChanged {
  return lastChanged;
}

- (NSArray*)allItems {
  return [clipboard items];
}

- (void)dealloc {
  [clipboard release];
  [clipboardView release];
  [changeListener release];
  [viewSlots release];
  [super dealloc];
}

@end

@implementation CBClipboardController(Delegation)

@end