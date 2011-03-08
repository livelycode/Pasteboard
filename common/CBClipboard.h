#import "Cocoa.h"

@class CBItem;

@interface CBClipboard : NSObject
{
    @private
    NSMutableArray *items;
    NSUInteger capacity;
}

- (id)init;

- (id)initWithCapacity:(NSUInteger)aCapacity;

- (void)setItem:(CBItem *)anItem atIndex:(NSUInteger)anIndex;

- (void)addItem:(CBItem *)anItem;

- (void)removeItemAtIndex:(NSUInteger)anIndex;

- (CBItem *)itemAtIndex:(NSUInteger)anIndex;

- (NSArray *)items;

@end