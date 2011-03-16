#import "Cocoa.h"
#import "CBItemViewDelegate.h"

@class CBApplicationController, CBDevicesViewController, CBSyncController, CBClipboard, CBPasteView;

@interface CBClipboardController : UIViewController {
@private
  NSInteger rows;
  NSInteger columns;
  CGFloat paddingTop;
  CGFloat paddingSides;
  CBClipboard* clipboard;
  CBApplicationController* delegate;
  IBOutlet UIView* clipboardView;
  CBPasteView* pasteButton;
  CBDevicesViewController* devicesViewController;
  NSMutableArray* itemViewSlots;
  NSMutableArray* frames;
  CBSyncController* syncController;
}
@end

@interface CBClipboardController(Delegation) <CBItemViewDelegate>
- (IBAction)devicesButtonTapped:(id)event;
@end

@interface CBClipboardController(Private)
@end