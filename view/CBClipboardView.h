#import "Cocoa.h"

@class CBItemView;
@class CBMatrix;

@interface CBClipboardView : NSView
{
    @private
    NSMutableArray *itemViews;
    NSColor *color;
    NSUInteger rows;
    NSUInteger columns;
    CGFloat cornerRadius;
}	

- (id)initWithFrame:(CGRect)aFrame
               Rows:(NSUInteger)numberRows
            Columns:(NSUInteger)numberColumns
      itemViewClass:(Class)itemClass;
	
- (void)drawRect:(NSRect)rect;

- (void)setCornerRadius:(CGFloat)aRadius;

- (void)setColor:(NSColor *)aColor;

- (void)setPadding:(CGFloat)thePadding;

- (NSView *)viewAtIndex:(NSUInteger)anIndex;

@end
