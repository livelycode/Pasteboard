#import "Cocoa.h"

@class CBGeneralController;
@class CBDevicesController;

@interface CBPreferencesController : NSWindowController {
  @private
  CBGeneralController *generalController;
  CBDevicesController *devicesController;
}

- (IBAction)showGeneralViewAnimated:(BOOL)performAnimation;

- (IBAction)showDevicesView;

@end