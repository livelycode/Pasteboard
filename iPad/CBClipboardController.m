#import "Cloudboard.h"

@implementation CBClipboardController

@end

@implementation CBClipboardController(Overriden)

- (void)viewDidLoad {
  [self.view setFrame:CGRectOffset(self.view.frame, 0, 22)];
  [self preparePopoverView];
  [self initializeItemViewFrames];
  [self drawPasteView];
  [self drawAllItems];
}

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}*/

/*- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  if((toInterfaceOrientation == UIInterfaceOrientationPortrait) || (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)) {
    [self setRowsForPortrait];
    NSLog(@"portrait");
  } else {
    [self setRowsForLandscape];
    NSLog(@"landscape");
  }
  CGRect newFrame = CGRectMake(0, 0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame));
  [self.view setFrame:newFrame];
  [frames removeAllObjects];
  [self initializeItemViewFrames];
  [UIView animateWithDuration:0.5 animations:^(void) {
    [self moveAllItemViews];
    [pasteButton setFrame:[[frames objectAtIndex:0] CGRectValue]];
  }];
}*/

- (void)dealloc {
  [clipboard release];
  [syncController release];
  [itemViewSlots release];
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