#import "Cocoa.h"

@class CBGeneralController;
@class CBDevicesController;

@interface CBPreferencesController : NSWindowController {
  @private  
  CBGeneralController *generalController;
  CBDevicesController *devicesController;
  NSView *intermediateView;
}

- (IBAction)showGeneralView:(id)sender;

- (IBAction)showDevicesView:(id)sender;

@end

@interface CBPreferencesController(Overridden)

- (void)windowDidLoad;

@end