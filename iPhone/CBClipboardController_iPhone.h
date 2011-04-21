#import "Cocoa.h"
#import "CBItemViewDelegate.h"
#import "CBClipboardController.h"

@class CBApplicationController, CBDevicesViewController, CBSyncController, CBClipboard, CBPasteView;

@interface CBClipboardController_iPhone : CBClipboardController {
@private
  CBPasteView* pasteButton;
}
- (id)initWithDelegate:(id)appController;
@end

@interface CBClipboardController_iPhone(Delegation) <CBItemViewDelegate>
- (IBAction)devicesButtonTapped:(id)event;
@end