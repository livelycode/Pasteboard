#import "Cloudboard.h"

@implementation CBPreferencesController

- (id)initWithWindowNibName:(NSString *)nibName {
    self = [super initWithWindowNibName:nibName];
    if (self) {
      [[self window] setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
      [[self window] setLevel:NSStatusWindowLevel];
      
      generalController = [[CBGeneralController alloc] initWithNibName:@"general" bundle:nil];
      devicesController = [[CBDevicesController alloc] initWithNibName:@"devices" bundle:nil];
      
      [self showGeneralViewAnimated:YES];
    }
    return self;
}

- (IBAction)showGeneralViewAnimated:(BOOL)performAnimation {
  CGRect newFrame = CGRectZero;
  CGPoint newOrigin =CGPointMake(500, 500);
  CGSize newSize = [[generalController view] frame].size;
  newFrame.size = newSize;
  newFrame.origin = newOrigin;
  [[self window] setFrame:newFrame display:YES animate:performAnimation];
}

- (IBAction)showDevicesView {
  
}

@end