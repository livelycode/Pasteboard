#import "Cloudboard.h"

@implementation CBClipboardController

- (id)initWithFrame:(CGRect) frame delegate: (id)delegate;
{
    self = [super init];
    if (self != nil)
    {
      CBClipboard* aClipboard = [[CBClipboard alloc] initWithCapacity:12];
      
      Class viewClass = [CBItemView class];
      CBClipboardView *aView = [[CBClipboardView alloc] initWithFrame:frame	
                                                                    Rows:4
                                                                 Columns:2
                                                        itemViewClass:viewClass];
      [aView setColor:[NSColor colorWithCalibratedWhite:0.7 alpha:1]];
      [aView setPadding:20];
      clipboard = aClipboard;
      clipboardView = aView;
      classes = [NSArray arrayWithObject:[NSAttributedString class]];
      [delegate addSubview: aView];
    }
    return self;
}	

@end

@implementation CBClipboardController(Delegation)

- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;
{
    NSArray *copiedItems = [aPasteboard readObjectsForClasses:classes
                                                      options:nil];
    for (NSAttributedString *string in copiedItems)
    {
        CBItem *item = [[CBItem alloc] initWithString:string];
        [clipboard insertItem:item
                      AtIndex:0];
    }
    
    for (CBItem *item in [clipboard items])
    {
        NSUInteger index = [[clipboard items] indexOfObject:item];
        id itemView = [clipboardView viewAtIndex:index];
        [itemView setText:[item string]];
    }
    [clipboardView setNeedsDisplay:YES];
}

@end