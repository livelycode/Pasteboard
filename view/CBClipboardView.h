#import "Cocoa.h"

@class CBItemView;

@interface CBClipboardView : NSView
{
    @private
    NSUInteger numberRows;
    NSUInteger numberColumns;
    CGFloat cornerRadius;
    NSColor *color;
    NSMutableArray *items;
}

- (id)init;

- (void)drawRect:(NSRect)rect;

- (id)initWithRows:(NSUInteger)rowsNumber
           Columns:(NSUInteger)columnsNumber;

- (NSUInteger)rows;

- (NSUInteger)columns;

- (void)setCornerRadius:(CGFloat)aRadius;

- (void)setColor:(NSColor *)aColor;

- (CBItemView *)itemViewForRow:(NSUInteger)aRow
                        column:(NSUInteger)aColumn;

@end
