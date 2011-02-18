#import "Cocoa.h"

@interface CBMatrix : NSObject
{
    @private
    NSUInteger rows;
    NSUInteger columns;
    NSMutableArray *objects;
}

- (id)initWithRows:(NSUInteger)numberRows
           columns:(NSUInteger)numberColumns;

- (void)setObjects:(NSArray *)newObjects;

- (void)setObject:(id)anObject
           forRow:(NSUInteger)aRow
           column:(NSUInteger)aColumn;

- (id)objectForRow:(NSUInteger)aRow
            column:(NSUInteger)aColumn;

@end