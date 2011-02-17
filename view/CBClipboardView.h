#import "Cocoa.h"

@class CBItemView;
@class CBMatrix;

@interface CBClipboardView : NSView
{
    @private
    CBMatrix *matrix;
    NSColor *color;
    CGFloat cornerRadius;
}

- (void)drawRect:(NSRect)rect;	

- (id)initWithFrame:(CGRect)aFrame
               Rows:(NSUInteger)numberRows
            Columns:(NSUInteger)numberColumns
      itemViewClass:(Class)itemClass;

- (void)setCornerRadius:(CGFloat)aRadius;

- (void)setColor:(NSColor *)aColor;

- (CBItemView *)itemViewForRow:(NSUInteger)aRow
                        column:(NSUInteger)aColumn;

@end
