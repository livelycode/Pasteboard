#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@class CBApplicationController;

@interface CBClipboardController : UIViewController {
@private
  UIToolbar* toolbar;
  CBClipboard* clipboard;
  CBApplicationController* delegate;
  NSMutableArray* viewSlots;
  NSMutableArray* frames;
  NSDate* lastChanged;
  id changeListener;
}

- (id)initWithDelegate:(id)viewController;
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
- (void)handleTapFromItemView:(CBItemView*)itemView index:(NSInteger)index;
- (void)devicesButtonTapped:(id)event;
@end

@interface CBClipboardController(Private)
- (void)drawItem:(CBItem *)item atViewIndex:(NSInteger)index;
- (void)removeViewAtViewIndex:(NSInteger)index;
- (void)drawPasteButton;
- (void)initializeItemViewFrames;
@end