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
- (void)stopSyncing;
- (void)startSyncing;
@end

@interface CBClipboardController(Delegation) <CBItemViewDelegate>
//UIGestureRecognizerDelegate
- (void)handleTapFromPasteView:(UITapGestureRecognizer *)recognizer;
- (void)handleTapFromItemView:(CBItemView*)itemView;
- (void)devicesButtonTapped:(id)event;
@end

@interface CBClipboardController(Private)
- (CGRect)rectForNSValue:(NSValue*)value;
- (void)drawPasteButton;
- (void)initializeItemViewFrames;
@end