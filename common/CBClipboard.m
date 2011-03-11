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
      NSFileManager *fileManager = [NSFileManager defaultManager];
      NSArray *urls = [fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask];
      if ([urls count] > 0) {
        NSURL *userDocumentsURL = [urls objectAtIndex:0];
        storeURL = [[NSURL alloc] initWithString:@"CBItems.plist" relativeToURL:userDocumentsURL];
      }
      [self loadItems];
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

- (CBItem *)itemAtIndex:(NSUInteger)anIndex {
    return [items objectAtIndex:anIndex];
}

- (NSArray *)items {
  	return [NSArray arrayWithArray:items];
}

- (void)persist {
  NSMutableArray* stringsToPersist = [NSMutableArray array];
  for(CBItem* item in items) {
    [stringsToPersist addObject:[item string]];
  }
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
  dispatch_async(queue,^{
    [stringsToPersist writeToURL:storeURL atomically:YES];
  });
}

- (void)dealloc {
  [items release];
  [super dealloc];
}

@end

@implementation CBClipboard(Private)

- (void)loadItems {
  NSArray* itemStringsReverse = [[NSArray alloc] initWithContentsOfURL:storeURL];
  NSArray* itemStrings = [[itemStringsReverse reverseObjectEnumerator] allObjects];
  if(itemStrings) {
    for(NSString* string in itemStrings) {
      [items addObject:[[CBItem alloc] initWithString:string]];
    }
  } else {
    [self clear]; 
  }
  NSLog(@"items loaded");
}

- (void)clear {
  [items removeAllObjects];
}

@end