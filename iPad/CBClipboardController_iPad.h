#import "Cocoa.h"
#import "CBItemViewDelegate.h"
#import "CBClipboardController.h"

@class CBApplicationController, CBDevicesViewController, CBSyncController, CBPasteView, CBClipboard;

@interface CBClipboardController_iPad : CBClipboardController {
@private
  UIPopoverController* popoverController;
  IBOutlet UIBarButtonItem* devicesButton;
  CBPasteView* pasteButton;
  IBOutlet UINavigationBar *toolbar;
}
- (id)initWithDelegate:(id)appController;
@end

@interface CBClipboardController_iPad(Delegation) <CBItemViewDelegate>
- (IBAction)devicesButtonTapped:(id)event;
@end

@interface CBClipboardController_iPad(Private)
- (void)preparePopoverView;
@end