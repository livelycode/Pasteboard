#import "Cloudboard.h"

@implementation CBClipboardController

- (id)initWithFrame:(CGRect) frame viewController: (id)viewController;
{
    self = [super init];
    if (self != nil)
    {
        clipboard = [[CBClipboard alloc] initWithCapacity:8];
      
        clipboardView = [[CBClipboardView alloc] initWithFrame:frame	
                                                                   Rows:4
                                                                Columns:2];
        [clipboardView setPadding:20];
        [clipboardView setDelegate:self];
        [viewController addSubview: clipboardView];
    }
    return self;
}

- (void)insertItem: (CBItem*) newItem atIndex: (NSInteger) index {
  [clipboard insertItem:newItem atIndex:0];
  for (CBItem *item in [clipboard items])
  {
    NSUInteger index = [[clipboard items] indexOfObject:item];
    id itemView = [clipboardView viewAtIndex:index];
    [itemView setText:[item string]];
  }
  [clipboardView setNeedsDisplay:YES];
  //notify changelistener:
  if(changeListener) {
    [changeListener insertedItem: newItem atIndex: index];
  }
}

- (void)addChangeListener: (id)listener {
  changeListener = listener;
}

- (void)didReceiveClickForItemAtIndex:(NSUInteger)anIndex
{
    NSLog(@"%i", anIndex);
}

- (void)didReceiveDismissClickFirItemAtIndex:(NSUInteger)anIndex
{
    NSLog(@"%i", anIndex);
}

@end