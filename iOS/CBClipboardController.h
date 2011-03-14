#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@class CBApplicationController, CBSyncController, CBPasteView;

@interface CBClipboardController : UIViewController {
@private
  NSInteger rows;
  NSInteger columns;
  UIToolbar* toolbar;
  CBClipboard* clipboard;
  CBApplicationController* delegate;
  UIBarButtonItem* devicesButton;
  UIPopoverController* popoverController;
  CBPasteView* pasteButton;
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
- (void)devicesButtonTapped:(id)event;
@end

@interface CBClipboardController(Private)
- (CGRect)rectForNSValue:(NSValue*)value;
- (CGRect)clipboardFrame;
- (void)drawToolbar;
- (void)preparePopoverView;
- (void)drawPasteButton;
- (void)setRowsForPortrait;
- (void)setRowsForLandscape;
- (void)initializeItemViewFrames;
@end