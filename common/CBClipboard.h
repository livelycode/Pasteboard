#import "Cocoa.h"

@class CBItem;

@interface CBClipboard : NSObject
{
  @private
  NSMutableArray *items;
  NSUInteger capacity;
  NSURL* storeURL;
}

- (id)init;

- (id)initWithCapacity:(NSUInteger)aCapacity;

- (void)addItem:(CBItem *)anItem;

- (CBItem*)itemAtIndex:(NSUInteger)anIndex;

- (NSArray*)items;

- (void)persist;

- (void)clear;

@end

@interface CBClipboard(Private)
- (void)loadItems;
@end