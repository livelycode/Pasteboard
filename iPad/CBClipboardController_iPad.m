#import "Cloudboard.h"
#import "CBClipboardController_iPad.h"
#import "CBDevicesViewController_iPad.h"

@implementation CBClipboardController_iPad

@end

@implementation CBClipboardController_iPad(Overriden)

- (void)viewDidLoad {
  devicesViewController = [[CBDevicesViewController_iPad alloc] initWithClipboard:self];
  [self.view setFrame:CGRectOffset(self.view.frame, 0, 20)];
  [self drawBackgroundLayers];
  [self preparePopoverView];
  [self initializeItemViewFrames];
  [self drawPasteView];
  [self drawAllItems];
  CGColorRef color = [[UIColor woodStructureColor] CGColor];
  CALayer *structureLayer = [CALayer layer];
  [structureLayer setFrame:toolbar.bounds];
  [structureLayer setBackgroundColor:color];
  [toolbar.layer addSublayer:structureLayer];
  [toolbar setTintColor:[UIColor woodBackgroundColor]];
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

@implementation CBClipboardController_iPad(Delegation)

//UIToolbarDelegate
- (IBAction)devicesButtonTapped:(id)event {
  if(popoverController.popoverVisible) {
    [popoverController dismissPopoverAnimated:NO]; 
  } else {
    [popoverController presentPopoverFromBarButtonItem:devicesButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];
  }
}
@end

@implementation CBClipboardController_iPad(Private)

- (void)preparePopoverView {
  popoverController = [[UIPopoverController alloc] initWithContentViewController:devicesViewController];
  popoverController.popoverContentSize = CGSizeMake(300, 300);
}

@end