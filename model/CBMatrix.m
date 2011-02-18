#import "Cloudboard.h"

@implementation CBMatrix

- (id)initWithRows:(NSUInteger)numberRows
           columns:(NSUInteger)numberColumns;
{
    self = [super init];
    if (self != nil)
    {
        rows = numberRows;
        columns = numberColumns;
    }
    return self;
}

- (void)setObjects:(NSArray *)newObjects
{
    [objects removeAllObjects];
    [objects addObjectsFromArray:newObjects];
}

- (void)setObject:(id)anObject
           forRow:(NSUInteger)aRow
           column:(NSUInteger)aColumn
{
    NSUInteger index = (aRow * columns) + aColumn;
    [objects insertObject:anObject
                  atIndex:index];
}

- (id)objectForRow:(NSUInteger)aRow
            column:(NSUInteger)aColumn
{
    NSUInteger index = (aRow * columns) + aColumn;
    return [objects objectAtIndex:index];
}

@end