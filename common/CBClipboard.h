#import "Cocoa.h"

@class CBItem;

@interface CBClipboard : NSObject
{
  @private
  NSMutableArray *items;
  NSUInteger capacity;
  NSURL* storeURL;
  NSDate* lastChanged;
}
- (id)init;
- (id)initWithCapacity:(NSUInteger)aCapacity;
- (void)addItem:(CBItem *)anItem;
- (CBItem*)itemAtIndex:(NSUInteger)anIndex;
- (NSArray*)items;
- (void)updateLastChanged;
- (void)setLastChanged:(NSDate*)date;
- (void)persist;
- (void)clear;
- (NSDate*)lastChanged;
@end

@interface CBClipboard(Private)
- (void)loadItems;
@end