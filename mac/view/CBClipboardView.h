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
  NSButton *settingsButton;
}	

- (id)init;

- (id)initWithFrame:(CGRect)aFrame
            padding:(CGFloat)thePadding
               Rows:(NSUInteger)numberRows
            Columns:(NSUInteger)numberColumns;
	
- (void)drawRect:(NSRect)rect;

- (void)setPadding:(CGFloat)thePadding;

- (NSUInteger)itemViews;

- (BOOL)itemAtIndexIsVisible:(NSUInteger)anIndex;

- (NSAttributedString *)stringForItemAtIndex:(NSUInteger)anIndex;

- (void)setDelegate:(id <CBClipboardViewDelegate>)anObject;

- (void)setString:(NSAttributedString *)aString
   forItemAtIndex:(NSUInteger)anIndex;

- (void)setAllViewItemsInvisible;

- (void)setVisible:(BOOL)isVisible
   forItemAtIndex:(NSUInteger)anIndex;

- (NSUInteger)invisibleItemsUpToIndex:(NSUInteger)anIndex;

- (void)startDragOperationWithEvent:(NSEvent *)anEvent
                             object:(id <NSPasteboardWriting>)anObject
                     forItemAtIndex:(NSUInteger)anIndex;

@end

@interface CBClipboardView(Delegation) <CBItemViewDelegate>

- (void)itemView:(CBItemView *)itemView
clickedWithEvent:(NSEvent *)anEvent;

- (void)itemView:(CBItemView *)itemView
   buttonClicked:(NSString *)aName
       withEvent:(NSEvent *)anEvent;

- (void)itemView:(CBItemView *)itemView
draggedWithEvent:(NSEvent *)anEvent;

- (void)itemView:(CBItemView *)itemView
  dropWithObject:(id <NSPasteboardReading>)anObject;

@end