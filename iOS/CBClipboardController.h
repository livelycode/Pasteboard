#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@interface CBClipboardController : NSObject {
@private
  CBClipboard* clipboard;
  UIView* clipboardView;
  NSMutableArray* viewSlots;
  NSMutableArray* frames;
  NSDate* lastChanged;
  id changeListener;
}

- (id)initWithFrame:(CGRect)aFrame viewController:(id)viewController;
- (void)setItemQuiet:(CBItem*)newItem atIndex:(NSInteger)anIndex;
- (void)setItem:(CBItem*)newItem atIndex:(NSInteger)anIndex;
- (NSDate*)lastChanged;
- (NSArray*)allItems;
- (BOOL)clipboardContainsItem:(CBItem*)anItem;

- (void)addChangeListener:(id)anObject;

@end

@interface CBClipboardController(Delegation) <CBItemViewDelegate>

@end

@interface CBClipboardController(Private)
- (void)drawItem:(CBItem*)item atIndex:(NSInteger)index;
- (void)drawPasteButtonAtIndex:(NSInteger)index;
- (void)initializeClipboardViewWithFrame:(CGRect)aFrame;
- (void)initializeItemViews;
@end