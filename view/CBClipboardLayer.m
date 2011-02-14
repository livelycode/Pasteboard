#import "Cloudboard.h"

@implementation CBClipboardLayer

- (id)init
{
    return [self initWithRows:1
                      Columns:1];
}

- (id)initWithRows:(NSUInteger)rowsNumber
           Columns:(NSUInteger)columnsNumber
{
    self = [super init];
    if (self != nil)
    {
        rows = rowsNumber;
        columns = columnsNumber;
    }
    return self;
}

- (void)setItemLayer:(CBItemLayer *)itemLayer
              forRow:(NSUInteger)aRow
              column:(NSUInteger)aColumn
{
    CGSize size = [self frame].size;
    CGFloat width = size.width / columns;
    CGFloat height = size.height / rows;
    CGPoint center = CGPointMake((width / 2), (height / 2));
    [itemLayer setPosition:center];
    [self addSublayer:itemLayer];
}

@end