#import "Cloudboard.h"

@implementation CBPreferencesController

- (id)initWithWindowNibName:(NSString *)nibName {
    self = [super initWithWindowNibName:nibName];
    if (self) {
      [[self window] setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
      [[self window] setLevel:NSStatusWindowLevel];
    }
    return self;
}

@end