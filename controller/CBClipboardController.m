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
                  atIndex:anIndex];
    
    if (changeListener != nil)
    {
        [changeListener insertedItem:newItem
                             atIndex:anIndex];
    }
    
    [clipboardView setAllViewItemsInvisible];
    for (CBItem *item in [clipboard items])
    {
        NSUInteger index = [[clipboard items] indexOfObject:item];
        NSAttributedString *string = [item string];
        [clipboardView setVisible:YES
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

@end

@implementation CBClipboardController(Delegation)

- (void)itemViewAtIndex:(NSUInteger)anIndex
       clickedWithEvent:(NSEvent *)anEvent
{
    NSUInteger newIndex = anIndex - [clipboardView invisibleItemsUpToIndex:anIndex];
    NSAttributedString *string = [[clipboard itemAtIndex:newIndex] string];
    NSPasteboard *systemPasteboard = [NSPasteboard generalPasteboard];
    [systemPasteboard clearContents];
    [systemPasteboard writeObjects:[NSArray arrayWithObject:string]];
}

- (void)didReceiveDismissClickForVisibleItemAtIndex:(NSUInteger)anIndex
{
    [clipboard removeItemAtIndex:anIndex];
}

- (void)didReceiveDraggingForVisibleItemAtIndex:(NSUInteger)anIndex
                                      withEvent:(NSEvent *)anEvent
{
    NSAttributedString *string = [[clipboard itemAtIndex:anIndex] string];
    [clipboardView startDragOperationWithEvent:anEvent
                                        object:string
                         forVisibleItemAtIndex:anIndex];
}

- (void)didReceiveDropWithObject:(id <NSPasteboardReading>)anObject
                 fromItemAtIndex:(NSUInteger)anIndex
{
    [clipboardView setVisible:YES
               forItemAtIndex:anIndex];
    [clipboardView setString:anObject
              forItemAtIndex:anIndex];
    
    CBItem *newItem = [[CBItem alloc] initWithString:anObject];
    NSUInteger newIndex = anIndex - [clipboardView invisibleItemsUpToIndex:anIndex];
    [clipboard insertItem:newItem
                  atIndex:newIndex];
}

@end