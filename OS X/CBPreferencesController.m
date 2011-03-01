#import "Cloudboard.h"

@implementation CBPreferencesController

- (id)initWithWindowNibName:(NSString *)nibName {
    self = [super initWithWindowNibName:nibName];
    if (self) {
      [[self window] setLevel:NSScreenSaverWindowLevel];
    }
    
    return self;
}

@end