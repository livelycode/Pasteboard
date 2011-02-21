#import "Cocoa.h"
#import "CBClipboardViewDelegate.h"
#import "CBItemViewDelegate.h"

@class CBItemView;

@interface CBClipboardView : NSView
{
    @private
    id delegate;
    NSMutableArray *itemViews;
    NSUInteger rows;
    NSUInteger columns;
}	

- (id)initWithFrame:(CGRect)aFrame
               Rows:(NSUInteger)numberRows
            Columns:(NSUInteger)numberColumns;
	
- (void)drawRect:(NSRect)rect;

- (void)setPadding:(CGFloat)thePadding;

- (void)setDelegate:(id <CBClipboardViewDelegate>)anObject;

- (void)setString:(NSAttributedString *)aString
   forItemAtIndex:(NSUInteger)anIndex;

- (void)setHidden:(BOOL)isHidden
   forItemAtIndex:(NSUInteger)anIndex;

@end

@interface CBClipboardView(Delegation) <CBItemViewDelegate>

- (void)itemViewClicked:(CBItemView *)itemView;

- (void)itemViewDismissButtonClicked:(CBItemView *)itemView;

@end