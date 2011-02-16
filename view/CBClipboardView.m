#import "Cloudboard.h"

@implementation CBClipboardView

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
        
        rootLayer = [CALayer layer];
        [rootLayer setBackgroundColor:CGColorCreateGenericGray(0, 0.5)];
        [self setLayer:rootLayer];
        [self setWantsLayer:YES];
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

- (void)setCornerRadius:(CGFloat)aRadius
{
    [rootLayer setCornerRadius:aRadius];
}

- (void)setOpacity:(CGFloat)anOpacity
{
    [rootLayer setOpacity:anOpacity];
}

- (CGSize)itemViewSize
{
    CGSize size = [self frame].size;
    CGFloat width = size.width / columns;
    CGFloat height = size.height / rows;
    return CGSizeMake(width, height);
}

- (void)setItemView:(CBItemView *)itemView
             forRow:(NSUInteger)aRow
             column:(NSUInteger)aColumn
{   
    CGSize itemSize = [self itemViewSize];
    CGFloat x = (aColumn - 1) * itemSize.width;
    CGFloat y = (rows - aRow) * itemSize.height;
    CGRect itemFrame = CGRectMake(x, y, itemSize.width, itemSize.height);
    [itemView setFrame:itemFrame];
    [self addSubview:itemView];
}

@end
