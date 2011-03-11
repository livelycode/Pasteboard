#import "Cloudboard.h"

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
      for(NSInteger i = 0; i<capacity; i++) {
        [items addObject:[NSNull null]];
      }
    }
    return self;
}

- (void)setItem:(id)anItem atIndex:(NSUInteger)anIndex {
    [items replaceObjectAtIndex:anIndex withObject:anItem];
}

- (void)addItem:(CBItem *)anItem {
  [items insertObject:anItem atIndex:0];
  
  if ([items count] > capacity) {
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