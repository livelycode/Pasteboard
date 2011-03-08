#import "Cloudboard.h"

#define ROWS 4
#define COLUMNS 2
#define PADDING 20

#define BUTTON_PADDING 16
#define BUTTON_HEIGHT 24
#define BUTTON_WIDTH 80

@implementation CBClipboardController(Private)

- (void)removeViewAtViewIndex:(NSInteger)index {
  if([viewSlots count] > index) {
    [[viewSlots objectAtIndex:index] removeFromSuperview];
  }
}

- (void)drawItem:(CBItem *)item atViewIndex:(NSInteger)index {
  CGRect frame = [[frames objectAtIndex:index] rectValue];
  CBItemView *itemView = [[CBItemView alloc] initWithFrame:frame index:index-1 content:[item string] delegate:self];
  [self removeViewAtViewIndex:index];
  if([viewSlots count] > index) {
    [viewSlots replaceObjectAtIndex:index withObject:itemView];
  } else {
    [viewSlots addObject:itemView];
  }
  [clipboardView addSubview:itemView];
}

- (void)drawPasteView {
  CGRect frame = [[frames objectAtIndex:0] rectValue];
  NSView *pasteView = [[CBPasteView alloc] initWithFrame:frame index:0 delegate:self];
  [self removeViewAtViewIndex:0];
  if([viewSlots count] > 0) {
    [viewSlots replaceObjectAtIndex:0 withObject:pasteView];
  } else {
    [viewSlots addObject:pasteView];
  }
  [clipboardView addSubview:pasteView];
}

- (void)initializeItemSlots {
  CGRect mainBounds = [clipboardView bounds];
  CGFloat itemWidth = (mainBounds.size.width - ((COLUMNS + 1) * PADDING)) / COLUMNS;
  CGFloat itemHeight = (mainBounds.size.height - ((ROWS + 1) * PADDING)) / ROWS;
  CGPoint origin = CGPointMake(PADDING, (mainBounds.size.height - itemHeight - PADDING));
  for(NSInteger row=0; row<ROWS; row++) {
    for(NSInteger column=0; column<COLUMNS; column++) {
      CGFloat x = origin.x + (column * (itemWidth + PADDING));
      CGFloat y = origin.y - (row * (itemHeight + PADDING));
      CGRect itemFrame = CGRectMake(x, y, itemWidth, itemHeight);
      [frames addObject:[NSValue valueWithRect:itemFrame]];
    }
  }
}

- (void)addButtonWithFrame:(CGRect)aRect title:(NSString *)aTitle action:(SEL)aSelector {
  NSButton *button = [[NSButton alloc] initWithFrame:aRect];
  [button setBezelStyle:NSTexturedRoundedBezelStyle];
  [button setTitle:aTitle];
  [button setTarget:self];
  [button setAction:aSelector];
  [clipboardView addSubview:button];
}

- (NSArray*)allItems {
  return [clipboard items];
}
@end

@implementation CBClipboardController

- (id)initWithFrame:(CGRect)aFrame viewController:(id)viewController {
  self = [super init];
  if (self != nil) {
    frames = [[NSMutableArray alloc] init];
    viewSlots = [[NSMutableArray alloc] init];
    clipboard = [[CBClipboard alloc] initWithCapacity:ROWS*COLUMNS-1];
    clipboardView = [[CBClipboardView alloc] initWithFrame:aFrame];
    lastChanged = [[NSDate alloc] init];
    [self initializeItemSlots];
    [self drawPasteView];
    [viewController addSubview:clipboardView];
    
    CGFloat clearX = BUTTON_PADDING;
    CGFloat clearY = BUTTON_PADDING;
    CGFloat clearWidth = BUTTON_WIDTH;
    CGFloat clearHeight = BUTTON_HEIGHT;
    CGRect clearFrame = CGRectMake(clearX, clearY, clearWidth, clearHeight);
    [self addButtonWithFrame:clearFrame title:@"Clear All" action:@selector(clearClipboard:)];
    
    CGFloat settingsX = CGRectGetWidth(aFrame) - BUTTON_WIDTH - BUTTON_PADDING;
    CGFloat settingsY = BUTTON_PADDING;
    CGFloat settingsWidth = BUTTON_WIDTH;
    CGFloat settingsHeight = BUTTON_HEIGHT;
    CGRect settingsFrame = CGRectMake(settingsX, settingsY, settingsWidth, settingsHeight);
    [self addButtonWithFrame:settingsFrame title:@"Settings" action:@selector(showSettings:)];
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
    if(syncController) {
      [syncController didSetItem:item atIndex:index];
    } 
  }
}

- (void)addItem:(CBItem *)item syncing:(BOOL)sync {
  [clipboard addItem:item];
  NSArray* items = [clipboard items];
  for(NSInteger index=0; index<(ROWS*COLUMNS-1); index++) {
    id object = [items objectAtIndex:index];
    if([object isEqual:[NSNull null]]) {
      [self removeViewAtViewIndex:index+1];
    } else {
      [self drawItem:object atViewIndex:index+1];
    }
  }
  if(sync) {
    if(syncController) {
      [syncController didAddItem:item];
    } 
  }
}

- (void)clearClipboard:(id)sender {
  for (int i=0; i < (ROWS * COLUMNS-1); i++) {
    [self setItem:[NSNull null] atIndex:i syncing:YES];
  }
}

- (void)showSettings:(id)sender {
  CBSettingsController *settings = [[CBSettingsController alloc] initWithSyncController:syncController];
  NSView *view = [settings view];
  [view setFrameOrigin:CGPointMake((NSWidth([clipboardView bounds]) - NSWidth([view frame])) / 2,
                                   (NSHeight([clipboardView bounds]) - NSHeight([view frame])) / 2
                                   )];
  [clipboardView addSubview:[settings view]];
}

- (BOOL)clipboardContainsItem:(CBItem *)item {
  return [[clipboard items] containsObject:item];
}

- (void)addSyncController:(id)object {
  syncController = object;
}

- (NSDate*)lastChanged {
  return lastChanged;
}

- (NSArray*)allItems {
  return [clipboard items];
}
@end

@implementation CBClipboardController(Delegation)
//CBItemViewDelegate
- (void)itemViewClicked:(CBItemView *)view index:(NSInteger)index {
  NSAttributedString *string = [[clipboard itemAtIndex:index] string];
  NSPasteboard *systemPasteboard = [NSPasteboard generalPasteboard];
  [systemPasteboard clearContents];
  [systemPasteboard writeObjects:[NSArray arrayWithObject:string]];
}

//CBPasteViewDelegate
- (void)pasteViewClicked:(CBItemView *)view index:(NSInteger)index {
  
}
@end