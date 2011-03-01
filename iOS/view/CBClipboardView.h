#import "Cocoa.h"
#import "CBClipboardViewDelegate.h"
#import "CBItemViewDelegate.h"

@class CBItemView;

@interface CBClipboardView : UIView
{
    @private
    id delegate;
    NSMutableArray *itemViews;
    NSUInteger rows;
    NSUInteger columns;
}	

- (id)init;

- (id)initWithFrame:(CGRect)aFrame
            padding:(CGFloat)thePadding
               Rows:(NSUInteger)numberRows
            Columns:(NSUInteger)numberColumns;
- (void)setDelegate:(id <CBClipboardViewDelegate>)anObject;
	
@end

@interface CBClipboardView(Delegation) <CBItemViewDelegate>

@end