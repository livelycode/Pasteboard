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
    
    if (changeListener != nil)
    {
        [changeListener insertedItem:newItem
                             atIndex:anIndex];
    }
    
    [clipboardView hideAllItems];
    for (CBItem *item in [clipboard items])
    {
        NSUInteger index = [[clipboard items] indexOfObject:item];
        NSAttributedString *string = [item string];
        [clipboardView setHidden:NO
                  forItemAtIndex:index];
        [clipboardView setString:string
                  forItemAtIndex:index];
    }
}

- (BOOL)clipboardContainsItem:(CBItem *)anItem
{
    return [[clipboard items] containsObject:anItem];
}

- (void)addChangeListener:(id)anObject
{
    changeListener = anObject;
}

- (void)didReceiveClickForItemAtIndex:(NSUInteger)anIndex
{
    NSAttributedString *string = [[clipboard itemAtIndex:anIndex] string];
    NSPasteboard *systemPasteboard = [NSPasteboard generalPasteboard];
    [systemPasteboard clearContents];
    [systemPasteboard writeObjects:[NSArray arrayWithObject:string]];
}

- (void)didReceiveDismissClickForItemAtIndex:(NSUInteger)anIndex
{
    NSLog(@"%i", anIndex);
}

@end