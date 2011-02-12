#import "Cloudboard.h"

@implementation CBClipboard

- (id)init
{
    return [self initWithCapacity:0];
}

- (id)initWithCapacity:(NSUInteger)aCapacity
{
    self = [super init];
    if (self != nil)
    {
        items = [NSMutableArray array];
        capacity = aCapacity;
    }
    return self;
}

- (void)setCapacity:(NSUInteger)aCapacity
{
    NSRange tail = NSMakeRange(aCapacity, [items count] - aCapacity);
    [items removeObjectsInRange:tail];
}

- (void)insertItem:(NSPasteboardItem *)anItem AtIndex:(NSUInteger)anIndex;
{
    [items insertObject:anItem
                atIndex:anIndex];
    if ([items count] > capacity)
    {
        [items removeLastObject];
    }
}

- (NSPasteboardItem *)itemAtIndex:(NSUInteger)anIndex
{
    return [items objectAtIndex:anIndex];
}

- (NSArray *)items
{
    return [NSArray arrayWithArray:items];
}

@end