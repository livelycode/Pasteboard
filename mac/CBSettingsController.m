#import "Cloudboard.h"

@implementation CBSettingsController

- (id)init {
    self = [super init];
    if (self) {
      windowController = [[CBSettingsController alloc] initWithWindowNibName:@"Settings"];
/*      NSWindow *settingsWindow = [settingsController window];
      [settingsWindow setLevel:NSScreenSaverWindowLevel];
      
      NSRect buttonFrame = NSMakeRect(20, 20, 200, 40);
      settingsButton = [[NSButton alloc] initWithFrame:buttonFrame];
      [settingsButton setTarget:settingsController];
      [settingsButton setAction:@selector(showWindow:)];
      [clipboardView addSubview:settingsButton];*/
    }
    
    return self;
}

@end