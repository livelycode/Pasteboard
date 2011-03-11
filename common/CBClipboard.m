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
      NSArray *urls = [fileManager URLsForDirectory:NSAutosavedInformationDirectory inDomains:NSUserDomainMask];
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
  [self persist];
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

- (void)persist {
  NSMutableArray* stringsToPersist = [NSMutableArray array];
  for(id object in items) {
    NSString* string;
    if([object isEqual: [NSNull null]]) {
      string = @"";
    } else {
      string = [object string];
    }
    [stringsToPersist addObject:string];
  }
  [stringsToPersist writeToURL:storeURL atomically:YES];
}

- (void)dealloc {
  [items release];
  [super dealloc];
}

@end

@implementation CBClipboard(Private)

- (void)loadItems {
  NSArray* itemStrings = [[NSArray alloc] initWithContentsOfURL:storeURL];
  if(itemStrings) {
    for(NSString* string in itemStrings) {
      if([string isEqualToString:@""]) {
        [items addObject:[NSNull null]];
      } else {
        [items addObject:[[CBItem alloc] initWithString:string]];
      }
    }
  } else {
    for(NSInteger i = 0; i<capacity; i++) {
      [items addObject:[NSNull null]];
    } 
  }
  NSLog(@"items loaded");
}

@end