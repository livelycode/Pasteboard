#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@class CBApplicationController, CBSyncController;

@interface CBClipboardController : UIViewController {
@private
  UIToolbar* toolbar;
  CBClipboard* clipboard;
  CBApplicationController* delegate;
  UIBarButtonItem* devicesButton;
  UIPopoverController* popoverController;
  NSMutableArray* viewSlots;
  NSMutableArray* frames;
  NSDate* lastChanged;
  CBSyncController* syncController;
}

- (id)initWithDelegate:(id)appController;
- (void)setItem:(id)newItem atIndex:(NSInteger)anIndex syncing:(BOOL)sync;
- (void)addItem:(CBItem *)item syncing:(BOOL)sync;
- (NSDate*)lastChanged;
- (NSArray*)allItems;
- (BOOL)clipboardContainsItem:(CBItem*)anItem;
- (void)addSyncController:(id)anObject;
- (CBSyncController*)syncController;
- (void)stopSyncing;
- (void)startSyncing;
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