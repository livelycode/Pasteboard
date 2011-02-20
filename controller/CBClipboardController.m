#import "Cloudboard.h"

@implementation CBClipboardController

- (id)initWithFrame:(CGRect) frame delegate: (id)delegate;
{
    self = [super init];
    if (self != nil)
    {
        CBClipboard* aClipboard = [[CBClipboard alloc] initWithCapacity:12];
      
        CBClipboardView *aView = [[CBClipboardView alloc] initWithFrame:frame	
                                                                   Rows:4
                                                                Columns:2];
        [aView setPadding:20];
        [aView setDelegate:self];
        clipboard = aClipboard;
        clipboardView = aView;
        [delegate addSubview: aView];
    }
    return self;
}	

-(void)insertItems: (NSArray*) items atIndex: (NSInteger) index {
  for(CBItem *item in items) {
    [clipboard insertItem:item AtIndex:0];
  }
  for (CBItem *item in [clipboard items])
  {
    NSUInteger index = [[clipboard items] indexOfObject:item];
    id itemView = [clipboardView viewAtIndex:index];
    [itemView setText:[item string]];
  }
  [clipboardView setNeedsDisplay:YES];
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