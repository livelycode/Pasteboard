#import "Cloudboard.h"

#define ROWS 4
#define COLUMNS 2
#define PADDING_TOP 40
#define PADDING_LEFT 20

@implementation CBClipboardController(Private)

- (void)drawItem:(CBItem *)item atViewIndex:(NSInteger)index {
  CGRect frame = [[frames objectAtIndex:index] CGRectValue];
  CBItemView *itemView = [[CBItemView alloc] initWithFrame:frame index:index-1 content:[item string] delegate:self];
  [self removeViewAtViewIndex:index];
  if([viewSlots count] > index) {
    [viewSlots replaceObjectAtIndex:index withObject:itemView];
  } else {
    [viewSlots addObject:itemView];
  }
  [clipboardView addSubview:itemView];
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
  [clipboardView addSubview:pasteView];
}

- (void)removeViewAtViewIndex:(NSInteger)index {
  if([viewSlots count] > index) {
    [[viewSlots objectAtIndex:index] removeFromSuperview];
  }
}

- (void)initializeClipboardViewWithFrame:(CGRect)aFrame {
  clipboardView = [[UIView alloc] initWithFrame:aFrame];
  [clipboardView setBackgroundColor:[UIColor lightGrayColor]];
  [clipboardView setNeedsDisplay];
}

- (void)initializeItemViews {
  NSInteger rows = ROWS;
  NSInteger columns = COLUMNS;
  NSInteger paddingTop = PADDING_TOP;
  NSInteger paddingLeft = PADDING_LEFT;
  CGRect mainBounds = [clipboardView bounds];
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

- (id)initWithFrame:(CGRect)aFrame delegate:(id)appController {
  self = [super init];
  if (self != nil) {
    clipboard = [[CBClipboard alloc] initWithCapacity:8];
    frames = [[NSMutableArray alloc] init];
    viewSlots = [[NSMutableArray alloc] init];
    lastChanged = [[NSDate alloc] init];
    [self initializeClipboardViewWithFrame: aFrame];
    [self initializeItemViews];
    [self drawPasteButton];
    delegate = appController;
    [delegate addSubview:clipboardView];
  }
  return self;
}

- (void)setItem:(CBItem *)item atIndex:(NSInteger)index syncing:(BOOL)sync {
  [clipboard setItem:item atIndex:index];
  [self drawItem:item atViewIndex:index+1];
  if(sync) {
    if(changeListener) {
      [changeListener didSetItem:item atIndex:index];
    } 
  }
}

- (void)addItem:(CBItem *)item syncing:(BOOL)sync {
  [clipboard insertItem:item atIndex:0];
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
    if(changeListener) {
      [changeListener didAddItem:item];
    } 
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
//UIGestureRecognizerDelegate
- (void)handleTapFromPasteView:(UITapGestureRecognizer *)recognizer {
  NSLog(@"tapped paste");
  CBItem* newItem = [delegate currentPasteboardItem];
  [self addItem:newItem syncing:YES];
}

@end