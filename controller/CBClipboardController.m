#import "Cloudboard.h"

@implementation CBClipboardController

- (id)initWithFrame:(CGRect)aFrame
     viewController:(id)viewController;
{
    self = [super init];
    if (self != nil)
    {
        clipboard = [[CBClipboard alloc] initWithCapacity:8];
      
        clipboardView = [[CBClipboardView alloc] initWithFrame:aFrame	
                                                          Rows:4
                                                       Columns:2];
        [clipboardView setPadding:20];
        [clipboardView setDelegate:self];
        [viewController addSubview:clipboardView];
    }
    return self;
}

- (void)insertItem:(CBItem *)newItem
           atIndex:(NSInteger)anIndex
{
    [clipboard insertItem:newItem
                  atIndex:0];
    
    for (CBItem *item in [clipboard items])
    {
        NSUInteger index = [[clipboard items] indexOfObject:item];
        id itemView = [clipboardView viewAtIndex:index];
        [itemView setText:[item string]];
    }
    
    if (changeListener != nil)
    {
        [changeListener insertedItem:newItem
                             atIndex:anIndex];
    }
}

- (void)addChangeListener:(id)anObject
{
    changeListener = anObject;
}

- (void)didReceiveClickForItemAtIndex:(NSUInteger)anIndex
{
    NSLog(@"%i", anIndex);
}

- (void)didReceiveDismissClickForItemAtIndex:(NSUInteger)anIndex
{
    NSLog(@"%i", anIndex);
}

@end