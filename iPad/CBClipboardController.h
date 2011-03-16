#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@class CBApplicationController, CBDevicesViewController, CBSyncController, CBPasteView;

@interface CBClipboardController : UIViewController {
@private
  NSInteger rows;
  NSInteger columns;
  CBClipboard* clipboard;
  CBApplicationController* delegate;
  IBOutlet UIView* clipboardView;
  UIPopoverController* popoverController;
  IBOutlet UIBarButtonItem* devicesButton;
  CBPasteView* pasteButton;
  CBDevicesViewController* devicesViewController;
  NSMutableArray* itemViewSlots;
  NSMutableArray* frames;
  CBSyncController* syncController;
}
- (id)initWithDelegate:(id)appController;
- (void)stopSyncing;
- (void)startSyncing;
@end

@interface CBClipboardController(Delegation) <CBItemViewDelegate>
//UIGestureRecognizerDelegate
- (void)handleTapFromPasteView:(CBPasteView*)view;
- (void)handleTapFromItemView:(CBItemView*)itemView;
- (IBAction)devicesButtonTapped:(id)event;
- (IBAction)clearAllButtonTapped:(id)event;
@end

@interface CBClipboardController(Private)
- (CGRect)rectForNSValue:(NSValue*)value;
- (CGRect)clipboardFrame;
- (void)drawToolbar;
- (void)preparePopoverView;
- (void)drawPasteButton;
- (void)setRowsForPortrait;
- (void)setRowsForLandscape;
- (void)moveAllItemViewsAnimated;
- (void)initializeItemViewFrames;
- (void)addItemView:(CBItemView *)itemView;
@end