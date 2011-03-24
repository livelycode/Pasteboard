#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@class CBApplicationController, CBDevicesViewController, CBSyncController, CBPasteView, CBClipboard;

@interface CBClipboardController : UIViewController {
@private
  NSInteger rows;
  NSInteger columns;
  CGFloat paddingTop;
  CGFloat paddingSides;
  CBClipboard* clipboard;
  CBApplicationController* delegate;
  IBOutlet UIView* clipboardView;
  CBDevicesViewController* devicesViewController;
  UIPopoverController* popoverController;
  IBOutlet UIBarButtonItem* devicesButton;
  CBPasteView* pasteButton;
  NSMutableArray* itemViewSlots;
  NSMutableArray* frames;
  CBSyncController* syncController;
  IBOutlet UINavigationBar *toolbar;
}
@end

@interface CBClipboardController(Delegation) <CBItemViewDelegate>
- (IBAction)devicesButtonTapped:(id)event;
@end

@interface CBClipboardController(Private)
- (void)preparePopoverView;
@end