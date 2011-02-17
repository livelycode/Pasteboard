#import "Cloudboard.h"

@implementation CBClipboardController

- (id)initWithClipboard:(CBClipboard *)aClipboard
                   view:(CBClipboardView *)aView;
{
    self = [super init];
    if (self != nil)
    {
        clipboard = aClipboard;
        clipboardView = aView;
    }
    return self;
}	

@end

@implementation CBClipboardController(Delegation)

- (void)systemPasteboardDidChange:(NSPasteboard *)aPasteboard;
{
/*    Class stringClass = [NSAttributedString class];
    NSArray *classes = [NSArray arrayWithObject:stringClass];
    NSArray *copiedItems = [aPasteboard readObjectsForClasses:classes
                                                      options:nil];
    
    for (NSAttributedString *string in copiedItems)
    {
        CBItem *item = [[CBItem alloc] initWithString:string];
        [clipboard insertItem:item
                      AtIndex:0];
    }
    
    NSUInteger row = 1;
    NSUInteger column = 1;
    for (CBItem *item in [clipboard items])
    {

        CBItemView *itemView = [clipboardView itemViewForRow:row
                                                      column:column];
        [itemView setPadding:20];
        [itemView setPageColor:[NSColor colorWithCalibratedRed:0.2
                                                         green:0.3
                                                          blue:0.4
                                                         alpha:1]];
        [itemView setShadowWithOpacity:0.5
                                radius:3
                                offset:5];
        [itemView setText:[item string]];
        
        column = column + 1;
        if (column > [clipboardView columns])
        {
            row = row + 1;
            column = 1;
        }
        [clipboardView needsDisplay]; 
    }*/
}

@end