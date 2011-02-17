#import "Cocoa.h"

@class CBItemView;

@interface CBClipboardView : NSView
{
    @private
    NSMatrix *matrix;
    NSUInteger numberRows;
    NSUInteger numberColumns;
    CGFloat cornerRadius;
    NSColor *color;
    NSMutableArray *items;
}

- (void)drawRect:(NSRect)rect;

- (id)initWithFrame:(CGRect)aFrame
               Rows:(NSUInteger)rowsNumber
           Columns:(NSUInteger)columnsNumber
          itemClass:(Class)itemClass;

- (NSUInteger)rows;

- (NSUInteger)columns;

- (void)setCornerRadius:(CGFloat)aRadius;

- (void)setColor:(NSColor *)aColor;

- (CBItemView *)itemViewForRow:(NSUInteger)aRow
                        column:(NSUInteger)aColumn;

@end
