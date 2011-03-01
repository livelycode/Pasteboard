#import "Cocoa.h"

@class CBGeneralController;
@class CBDevicesController;

@interface CBPreferencesController : NSWindowController {
  @private  
  CBGeneralController *generalController;
  CBDevicesController *devicesController;
}

- (IBAction)showGeneralView:(id)sender;

- (IBAction)showDevicesView:(id)sender;

- (void)resizeWindowWithViewFrame:(NSRect)newFrame;

@end