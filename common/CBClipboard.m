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
        items = [[NSMutableArray alloc] init];
        capacity = aCapacity;
    }
    return self;
}

- (void)insertItem:(CBItem *)anItem
           atIndex:(NSUInteger)anIndex;
{
    [items insertObject:anItem
                atIndex:anIndex];
    if ([items count] > capacity)
    {
        NSRange tail = NSMakeRange(capacity, [items count] - capacity);
        [items removeObjectsInRange:tail];
    }
}

- (void)removeItemAtIndex:(NSUInteger)anIndex
{
    [items removeObjectAtIndex:anIndex];
}

- (CBItem *)itemAtIndex:(NSUInteger)anIndex
{
    return [items objectAtIndex:anIndex];
}

- (NSArray *)items
{
  	return [NSArray arrayWithArray:items];
}

- (void)dealloc {
  [items release];
  [super dealloc];
}

@end