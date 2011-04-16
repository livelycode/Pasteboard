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
      lastChanged = [[NSDate alloc] initWithTimeIntervalSince1970:0];
      NSFileManager *fileManager = [NSFileManager defaultManager];
      NSArray *urls = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
      if ([urls count] > 0) {
        NSURL *appSupportURL = [urls objectAtIndex:0];
        NSURL *ourAppSupportURL = [appSupportURL URLByAppendingPathComponent:@"Pasteboard"];
        [fileManager createDirectoryAtPath:[ourAppSupportURL path] withIntermediateDirectories:YES attributes:nil error:NULL];
        storeURL = [[NSURL alloc] initWithString:@"items.plist" relativeToURL:ourAppSupportURL];
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
}

- (CBItem *)itemAtIndex:(NSUInteger)anIndex {
    return [items objectAtIndex:anIndex];
}

- (NSArray *)items {
  	return [NSArray arrayWithArray:items];
}

- (void)updateLastChanged {
  [self setLastChanged:[NSDate date]];
}

- (void)setLastChanged:(NSDate*)date {
  [lastChanged autorelease];
  lastChanged = [[NSDate alloc] init];
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
  [storeURL release];
  [lastChanged release];
  [super dealloc];
}

@end

@implementation CBClipboard(Private)

- (void)loadItems {
  NSDictionary* itemData = [NSDictionary dictionaryWithContentsOfURL:storeURL];
  if(itemData) {
    [lastChanged release];
    lastChanged = [[itemData valueForKey:@"date"] retain];
    NSArray* itemStringsReverse = [itemData valueForKey:@"items"];
    NSArray* itemStrings = [[itemStringsReverse reverseObjectEnumerator] allObjects];
    for(NSString* string in itemStrings) {
      [items addObject:[[[CBItem alloc] initWithString:string] autorelease]];
    }
  } else {
    [self clear]; 
  }
}

@end