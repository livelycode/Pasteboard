#import "Cocoa.h"

@class CBGeneralController;
@class CBDevicesController;

@interface CBPreferencesController : NSWindowController {
  @private  
  CBApplicationController* appController;
  CBGeneralController *generalController;
  CBDevicesController *devicesController;
  NSView *intermediateView;
}
- (id)initWithAppController:(CBApplicationController*)appController;

- (IBAction)showGeneralView:(id)sender;

- (IBAction)showDevicesView:(id)sender;

@end

@interface CBPreferencesController(Overridden)

- (void)windowDidLoad;

@end