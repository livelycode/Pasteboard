#import "Cloudboard.h"

#define ROWS 4
#define COLUMNS 2
#define PADDING 0

#define BUTTON_PADDING 16
#define BUTTON_HEIGHT 24
#define BUTTON_WIDTH 80

@implementation CBClipboardController(Private)
- (CGRect)rectForNSValue:(NSValue*)value {
  return [value rectValue];
}

- (void)drawPasteView {
  CGRect frame = [[frames objectAtIndex:0] rectValue];
  NSView *pasteView = [[CBPasteView alloc] initWithFrame:frame delegate:self];
  [[self view] addSubview:pasteView];
}

- (void)initializeItemSlots {
  CGRect mainBounds = [[self view] bounds];
  NSUInteger itemWidth = (mainBounds.size.width - ((COLUMNS + 1) * PADDING)) / COLUMNS;
  NSUInteger itemHeight = (mainBounds.size.height - ((ROWS + 1) * PADDING)) / ROWS;
  CGPoint origin = CGPointMake(PADDING, (mainBounds.size.height - itemHeight - PADDING));
  for(NSInteger row=0; row<ROWS; row++) {
    for(NSInteger column=0; column<COLUMNS; column++) {
      NSUInteger x = origin.x + (column * (itemWidth + PADDING));
      NSUInteger y = origin.y - (row * (itemHeight + PADDING));
      CGRect itemFrame = CGRectMake(x, y, itemWidth, itemHeight);
      [frames addObject:[NSValue valueWithRect:itemFrame]];
    }
  }
}

@end

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

- (id)initWithFrame:(CGRect)aFrame {
  self = [super initWithNibName:@"clipboard" bundle:nil];
  if (self != nil) {
    frames = [[NSMutableArray alloc] init];
    itemViewSlots = [[NSMutableArray alloc] init];
    clipboard = [[CBClipboard alloc] initWithCapacity:ROWS*COLUMNS-1];
    lastChanged = [[NSDate alloc] init];
    [[self view] setFrame:aFrame];
    [self initializeItemSlots];
    [self drawPasteView];
    for(id item in [clipboard items]) {
      [self drawItem:item];
    }
  }
  return self;
}

- (void)setSyncController:(CBSyncController *)controller {
  syncController = controller;
}

- (void)setWindowController:(CBMainWindowController *)aController {
  windowController = aController;
}

- (CALayer *)snapShot {
  NSView *view = [self view];
  NSImage *image = [[NSImage alloc] initWithData:[view dataWithPDFInsideRect:[view bounds]]];  
  CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)[image TIFFRepresentation], NULL);
  CGImageRef imageRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
  
  CALayer *layer = [[CALayer alloc] init];
  [layer setFrame:[view bounds]];
  [layer setContents:(id)imageRef];
  return layer;
}
@end