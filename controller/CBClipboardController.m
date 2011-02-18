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
        classes = [NSArray arrayWithObject:[NSAttributedString class]];
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