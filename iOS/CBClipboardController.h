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
  NSMutableArray* itemViewSlots;
  NSMutableArray* frames;
  NSDate* lastChanged;
  CBSyncController* syncController;
}

- (id)initWithDelegate:(id)appController;
- (void)addItem:(CBItem *)item syncing:(BOOL)sync;
- (NSDate*)lastChanged;
- (NSArray*)allItems;
- (BOOL)clipboardContainsItem:(CBItem*)anItem;
- (void)addSyncController:(id)anObject;
- (CBSyncController*)syncController;
- (void)stopSyncing;
- (void)startSyncing;
- (void)persistClipboard;
- (void)clearClipboardSyncing:(BOOL)sync;
@end

@interface CBClipboardController(Delegation) <CBItemViewDelegate>
//UIGestureRecognizerDelegate
- (void)handleTapFromPasteView:(UITapGestureRecognizer *)recognizer;
- (void)handleTapFromItemView:(CBItemView*)itemView;
- (void)devicesButtonTapped:(id)event;
@end

@interface CBClipboardController(Private)
- (void)drawPasteButton;
- (void)initializeItemViewFrames;
@end