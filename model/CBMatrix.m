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
        NSUInteger numberObjects = rows * columns;
        objects = [[NSMutableArray alloc] initWithCapacity:numberObjects];
        while (numberObjects > 0)
        {
            [objects addObject:[NSNull null]];
            numberObjects = numberObjects - 1;
        }
    }
    return self;
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