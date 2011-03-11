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

- (void)setItem:(id)anItem atIndex:(NSUInteger)anIndex;

- (void)addItem:(CBItem *)anItem;

- (void)removeItemAtIndex:(NSUInteger)anIndex;

- (CBItem *)itemAtIndex:(NSUInteger)anIndex;

- (NSArray *)items;

- (void)persist;

@end

@interface CBClipboard(Private)
- (void)loadItems;
@end