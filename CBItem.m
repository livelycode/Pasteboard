#import "Cloudboard.h"

@implementation CBItem

- (id)initWithPasteboardItem:(NSPasteboardItem *)anItem
{
    self = [super init];
    if (self != nil)
    {
        pasteboardItem = anItem;
    }
    return self;
}

@end