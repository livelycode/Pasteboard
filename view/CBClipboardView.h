#import "Cocoa.h"

@class CBItemView;

@interface CBClipboardView : NSView
{
    @private
    NSUInteger rows;
    NSUInteger columns;
    CALayer *rootLayer;
}

- (id)init;

- (id)initWithRows:(NSUInteger)rowsNumber
           Columns:(NSUInteger)columnsNumber;

- (NSUInteger)rows;

- (NSUInteger)columns;

- (void)setCornerRadius:(CGFloat)aRadius;

- (void)setOpacity:(CGFloat)anOpacity;

- (CGSize)itemViewSize;

- (void)setItemView:(CBItemView *)itemView
             forRow:(NSUInteger)aRow
             column:(NSUInteger)aColumn;

@end
