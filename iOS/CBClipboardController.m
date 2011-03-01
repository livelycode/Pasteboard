#import "Cloudboard.h"

@implementation CBClipboardController

- (id)initWithFrame:(CGRect)aFrame viewController:(id)viewController {
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

- (void)insertItem:(CBItem *)newItem atIndex:(NSInteger)anIndex {
  [clipboard insertItem:newItem atIndex:anIndex];
  NSAttributedString *string = [newItem string];
  [clipboardView setVisible:YES forItemAtIndex:anIndex];
  [clipboardView setString:string forItemAtIndex:anIndex];
  if (changeListener != nil)
  {
    [changeListener insertedItem:newItem atIndex:anIndex];
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

@end