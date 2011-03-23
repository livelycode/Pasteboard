#import "Cloudboard.h"

@implementation CBClipboardController

@end

@implementation CBClipboardController(Overriden)

- (void)viewDidLoad {
  [self.view setFrame:CGRectOffset(self.view.frame, 0, 22)];
  [self drawBackgroundLayers];
  [self preparePopoverView];
  [self initializeItemViewFrames];
  [self drawPasteView];
  [self drawAllItems];
}

- (void)viewDidUnload {
  [clipboardView release];
  [devicesButton release];
}

- (void)dealloc {
  [clipboard release];
  [delegate release];
  [devicesViewController release];
  [popoverController release];
  [pasteButton release];
  [itemViewSlots release];
  [frames release];
  [syncController release];
  [super dealloc];
}
@end

@implementation CBClipboardController(Delegation)

//UIToolbarDelegate
- (IBAction)devicesButtonTapped:(id)event {
  if(popoverController.popoverVisible) {
    [popoverController dismissPopoverAnimated:NO]; 
  } else {
    [popoverController presentPopoverFromBarButtonItem:devicesButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];
  }
}
@end

@implementation CBClipboardController(Private)

- (void)preparePopoverView {
  popoverController = [[UIPopoverController alloc] initWithContentViewController:devicesViewController];
  popoverController.popoverContentSize = CGSizeMake(300, 300);
}

@end