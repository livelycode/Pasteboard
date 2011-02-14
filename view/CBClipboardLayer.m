#import "Cloudboard.h"

@implementation CBClipboardLayer

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        itemLayers = [NSMutableArray array];
    }
    return self;
}

- (void)setItemLayer:(CBItemLayer *)itemLayer
              forRow:(NSUInteger)aRow
              column:(NSUInteger)aColumn
{
    
}

@end