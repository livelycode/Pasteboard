#import "Cloudboard.h"

#define COUNT 7

@implementation CBClipboard

- (id)init {
    return [self initWithCapacity:0];
}

- (id)initWithCapacity:(NSUInteger)aCapacity {
    self = [super init];
    if (self != nil)
    {
      items = [[NSMutableArray alloc] init];
      capacity = aCapacity;
      for(NSInteger i = 0; i<COUNT; i++) {
        [items addObject:[NSNull null]];
      }
    }
    return self;
}

- (void)setItem:(CBItem*)anItem atIndex:(NSInteger)anIndex {
  [items replaceObjectAtIndex:anIndex withObject:anItem];
}

- (void)insertItem:(CBItem *)anItem atIndex:(NSUInteger)anIndex {
    [items insertObject:anItem atIndex:anIndex];
    if ([items count] > capacity)
    {
        NSRange tail = NSMakeRange(capacity, [items count] - capacity);
        [items removeObjectsInRange:tail];
    }
}

- (void)removeItemAtIndex:(NSUInteger)anIndex {
    [items replaceObjectAtIndex:anIndex withObject: [NSNull null]];
}

- (CBItem *)itemAtIndex:(NSUInteger)anIndex {
    return [items objectAtIndex:anIndex];
}

- (NSArray *)items {
  	return [NSArray arrayWithArray:items];
}

- (void)dealloc {
  [items release];
  [super dealloc];
}

@end