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
      lastChanged = [NSDate dateWithTimeIntervalSince1970:0];
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

- (void)addItem:(CBItem *)anItem {
  NSLog(@"clipboard: addItem");
  [items insertObject:anItem atIndex:0];
  if ([items count] > capacity) {
    NSRange tail = NSMakeRange(capacity, [items count] - capacity);
    [items removeObjectsInRange:tail];
  }
  lastChanged = [[NSDate alloc] init];
}

- (CBItem *)itemAtIndex:(NSUInteger)anIndex {
    return [items objectAtIndex:anIndex];
}

- (NSArray *)items {
  	return [NSArray arrayWithArray:items];
}

- (void)persist {
  NSMutableDictionary* itemData = [NSMutableDictionary dictionary];
  [itemData setValue:lastChanged forKey:@"date"];
  NSMutableArray* stringsToPersist = [NSMutableArray array];
  for(CBItem* item in items) {
    [stringsToPersist addObject:[item string]];
  }
  [itemData setValue:stringsToPersist forKey:@"items"];
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
  dispatch_async(queue,^{
    [itemData writeToURL:storeURL atomically:YES];
  });
}

- (NSDate*)lastChanged {
  return lastChanged;
}

- (void)clear {
  [items removeAllObjects];
}

- (void)dealloc {
  [items release];
  [super dealloc];
}

@end

@implementation CBClipboard(Private)

- (void)loadItems {
  NSDictionary* itemData = [[NSDictionary alloc] initWithContentsOfURL:storeURL];
  if(itemData) {
    lastChanged = [itemData valueForKey:@"date"];
    NSArray* itemStringsReverse = [itemData valueForKey:@"items"];
    NSArray* itemStrings = [[itemStringsReverse reverseObjectEnumerator] allObjects];
    for(NSString* string in itemStrings) {
      [items addObject:[[CBItem alloc] initWithString:string]];
    }
  } else {
    [self clear]; 
  }
  NSLog(@"items loaded");
}

@end