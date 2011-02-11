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

- (NSString *)bestMatchForArray:(NSArray *)URIs;
{
    return [pasteboardItem availableTypeFromArray:URIs];
}

@end