#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@class CBApplicationController;

@interface CBClipboardController : NSObject {
@private
  CBClipboard* clipboard;
  CBApplicationController* delegate;
  UIView* coordView;
  UIView* clipboardView;
  NSMutableArray* viewSlots;
  NSMutableArray* frames;
  NSDate* lastChanged;
  id changeListener;
}

- (id)initWithFrame:(CGRect)aFrame delegate:(id)viewController;
- (void)setItem:(CBItem*)newItem atIndex:(NSInteger)anIndex syncing:(BOOL)sync;
- (void)addItem:(CBItem *)item syncing:(BOOL)sync;
- (NSDate*)lastChanged;
- (NSArray*)allItems;
- (BOOL)clipboardContainsItem:(CBItem*)anItem;

- (void)addChangeListener:(id)anObject;

@end

@interface CBClipboardController(Delegation) <CBItemViewDelegate>
//UIGestureRecognizerDelegate
- (void)handleTapFromPasteView:(UITapGestureRecognizer *)recognizer;
@end

@interface CBClipboardController(Private)
- (void)drawItem:(CBItem *)item atViewIndex:(NSInteger)index;
- (void)removeViewAtViewIndex:(NSInteger)index;
- (void)drawPasteButton;
- (void)initializeClipboardViewWithFrame:(CGRect)aFrame;
- (void)initializeItemViews;
@end