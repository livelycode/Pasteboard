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

- (NSUInteger)rows
{
    return rows;
}

- (NSUInteger)columns
{
    return columns;
}

- (CGSize)itemLayerSize
{
    CGSize size = [self frame].size;
    CGFloat width = size.width / columns;
    CGFloat height = size.height / rows;
    return CGSizeMake(width, height);
}

- (void)setItemLayer:(CBItemLayer *)itemLayer
              forRow:(NSUInteger)aRow
              column:(NSUInteger)aColumn
{   
    CGSize itemSize = [self itemLayerSize];
    CGFloat x = (aColumn - 1) * itemSize.width;
    CGFloat y = (rows - aRow) * itemSize.height;
    CGRect itemFrame = CGRectMake(x, y, itemSize.width, itemSize.height);
    [itemLayer setFrame:itemFrame];
    [self addSublayer:itemLayer];
}

@end