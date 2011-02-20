#import "Cocoa.h"

@class CBItemView;
@class CBMatrix;

@interface CBClipboardView : NSView
{
    @private
    NSMutableArray *itemViews;
    NSUInteger rows;
    NSUInteger columns;
	}	

- (id)initWithFrame:(CGRect)aFrame
               Rows:(NSUInteger)numberRows
            Columns:(NSUInteger)numberColumns
      itemViewClass:(Class)itemClass;
	
- (void)drawRect:(NSRect)rect;

- (void)setPadding:(CGFloat)thePadding;

- (NSView *)viewAtIndex:(NSUInteger)anIndex;

@end
