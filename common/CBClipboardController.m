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
                                                       padding:20
                                                          Rows:4
                                                       Columns:2];
        [clipboardView setDelegate:self];
        [viewController addSubview:clipboardView];
    }
    return self;
}

- (void)insertItem:(CBItem *)newItem
           atIndex:(NSInteger)anIndex
{
    NSUInteger newIndex = anIndex - [clipboardView invisibleItemsUpToIndex:anIndex];
    [clipboard insertItem:newItem
                  atIndex:newIndex];
    
    NSUInteger indexMove = [clipboardView itemViews] - 1;
    while (indexMove != anIndex)
    {
        NSUInteger previousIndex = indexMove - 1;
        BOOL previousVisible = [clipboardView itemAtIndexIsVisible:previousIndex];
        NSAttributedString *previousString = [clipboardView stringForItemAtIndex:previousIndex];
        [clipboardView setVisible:previousVisible
                   forItemAtIndex:indexMove];
        [clipboardView setString:previousString
                  forItemAtIndex:indexMove];
        indexMove = indexMove - 1;
    }
    
    NSAttributedString *string = [newItem string];
    [clipboardView setVisible:YES
               forItemAtIndex:anIndex];
    [clipboardView setString:string
              forItemAtIndex:newIndex];
    
    if (changeListener != nil)
    {
        [changeListener insertedItem:newItem
                             atIndex:anIndex];
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
  [super dealloc];
}

@end

@implementation CBClipboardController(Delegation)

- (void)clipboardView:(CBClipboardView *)aClipboardView
      didReceiveClick:(NSEvent *)theEvent
       forItemAtIndex:(NSUInteger)anIndex
{
    NSUInteger newIndex = anIndex - [clipboardView invisibleItemsUpToIndex:anIndex];
    NSAttributedString *string = [[clipboard itemAtIndex:newIndex] string];
    NSPasteboard *systemPasteboard = [NSPasteboard generalPasteboard];
    [systemPasteboard clearContents];
    [systemPasteboard writeObjects:[NSArray arrayWithObject:string]];
}

- (void)clipboardView:(CBClipboardView *)aClipboardView
      didReceiveClick:(NSEvent *)theEvent
    forButtonWithName:(NSString *)aName
              atIndex:(NSUInteger)anIndex
{
    NSUInteger newIndex = anIndex - [clipboardView invisibleItemsUpToIndex:anIndex];
    [clipboard removeItemAtIndex:newIndex];
    [clipboardView setVisible:NO
               forItemAtIndex:anIndex];
}

@end