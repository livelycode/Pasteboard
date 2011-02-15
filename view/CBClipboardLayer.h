#import "Cocoa.h"

@class CBItemLayer;

@interface CBClipboardLayer : CALayer
{
    @private
    NSUInteger rows;
    NSUInteger columns;
}

- (id)init;

- (id)initWithRows:(NSUInteger)rowsNumber
           Columns:(NSUInteger)columnsNumber;

- (NSUInteger)rows;

- (NSUInteger)columns;

- (CGSize)itemLayerSize;

- (void)setItemLayer:(CBItemLayer *)itemLayer
              forRow:(NSUInteger)aRow
              column:(NSUInteger)aColumn;

@end
