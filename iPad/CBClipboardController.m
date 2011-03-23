#import "Cloudboard.h"

@implementation CBClipboardController

@end

@implementation CBClipboardController(Overriden)

- (void)viewDidLoad {
  [self.view setFrame:CGRectOffset(self.view.frame, 0, 22)];
  
  UIColor *startingColor = [UIColor colorWithRed:(172.0/255) green:(114.0/255) blue:(44.0/255) alpha:1];
  UIColor *endingColor = [UIColor colorWithRed:(129.0/255) green:(67.0/255) blue:(21.0/255) alpha:1];
  CAGradientLayer *gradientLayer = [CAGradientLayer layer];
  gradientLayer.colors = [NSArray arrayWithObjects: (id)[startingColor CGColor], (id)[endingColor CGColor], nil];
  UIImage *structure = [UIImage imageNamed:@"Structure.png"];

  CALayer *structureLayer = [CALayer layer];
  structureLayer.backgroundColor = [[UIColor colorWithPatternImage:structure] CGColor];
  
  gradientLayer.frame = clipboardView.layer.bounds;
  structureLayer.frame = clipboardView.layer.bounds;
  
  [clipboardView.layer addSublayer: gradientLayer];
  [clipboardView.layer addSublayer:structureLayer];
  
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