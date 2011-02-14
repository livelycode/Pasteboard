#import "Cocoa.h"

@class CBItemLayer;

@interface CBClipboardLayer : CALayer
{
    @private
    NSMutableArray *itemLayers;
}

- (void)setItemLayer:(CBItemLayer *)itemLayer
              forRow:(NSUInteger)aRow
              column:(NSUInteger)aColumn;

@end
