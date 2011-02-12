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

- (void)setCapacity:(NSUInteger)aCapacity;

- (void)insertItem:(NSPasteboardItem *)anItem AtIndex:(NSUInteger)anIndex;

- (NSPasteboardItem *)itemAtIndex:(NSUInteger)anIndex;

- (NSArray *)items;

@end