#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@class CBClipboard;
@class CBClipboardView;

@interface CBClipboardController : NSObject {
  @private
  id changeListener;
  CBClipboard *clipboard;
  CBClipboardView *clipboardView;
  NSMutableArray *frames;
  NSMutableArray *itemViews;
}
- (void)setItemQuiet:(CBItem*)newItem atIndex:(NSInteger)anIndex;
- (void)setItem:(CBItem *)item atIndex:(NSInteger)index;
- (void)addItem:(CBItem *)item;
- (BOOL)clipboardContainsItem:(CBItem *)item;
- (void)addChangeListener:(id)object;

@end

@interface CBClipboardController(Overridden)
- (id)initWithFrame:(CGRect)aFrame viewController:(id)viewController;
@end

@interface CBClipboardController(Delegation) <CBItemViewDelegate>
- (void)itemView:(CBItemView *)view clickedWithEvent:(NSEvent *)event;
- (void)itemView:(CBItemView *)view areaClicked:(CBItemViewArea)area withEvent:(NSEvent *)event;
- (void)itemView:(CBItemView *)view draggedWithEvent:(NSEvent *)event;
- (void)itemView:(CBItemView *)view didReceiveDropWithObject:(id <NSPasteboardReading>)object;
@end