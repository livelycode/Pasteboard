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

- (void)updateItemViews
{
    NSUInteger row = 1;
    NSUInteger column = 1;
    for (CBItem *item in [clipboard items])
    {
        CBSettings *settings = [CBSettings sharedSettings];
        CGFloat opacity = [settings floatForKey:@"shadowOpacity"];
        CGFloat radius = [settings floatForKey:@"shadowRadius"];
        CGFloat offset = [settings floatForKey:@"shadowOffset"];
        CGFloat padding = [settings floatForKey:@"pagePadding"];
        CGFloat red = [settings floatForKey:@"pageRed"];
        CGFloat green = [settings floatForKey:@"pageGreen"];
        CGFloat blue = [settings floatForKey:@"pageBlue"];
        CGSize itemSize = [clipboardView itemViewSize];
        
        CBItemView *itemView = [[CBItemView alloc] initWithContentSize:itemSize];
        [itemView setPadding:padding];
        [itemView setPageColor:[NSColor colorWithCalibratedRed:red
                                                         green:green
                                                          blue:blue
                                                         alpha:1]];
        [itemView setShadowWithOpacity:opacity
                                radius:radius
                                offset:offset];
        [itemView setText:[item string]];
                
        [clipboardView setItemView:itemView
                            forRow:row
                            column:column];
        column = column + 1;
        if (column > [clipboardView columns])
        {
            row = row + 1;
            column = 1;
        }
        [clipboardView needsDisplay]; 
    }
    
}

@end