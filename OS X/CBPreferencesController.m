#import "Cloudboard.h"

@implementation CBPreferencesController

- (id)initWithWindowNibName:(NSString *)nibName {
    self = [super initWithWindowNibName:nibName];
    if (self) {
      [[self window] setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
      [[self window] setLevel:NSStatusWindowLevel];
      
      generalController = [[CBGeneralController alloc] initWithNibName:@"general" bundle:nil];
      devicesController = [[CBDevicesController alloc] initWithNibName:@"devices" bundle:nil];
      
      [self showGeneralView:nil];
    }
    return self;
}

- (void)windowDidLoad {
  [[[self window] toolbar] validateVisibleItems];
}

- (IBAction)showGeneralView:(id)sender {
  NSView *contentView = [[self window] contentView];
  NSView *generalView = [generalController view];
  [self resizeWindowWithViewFrame:[generalView frame]];
  [contentView setSubviews:[NSArray arrayWithObject:generalView]];
}

- (IBAction)showDevicesView:(id)sender {
  NSView *contentView = [[self window] contentView];
  NSView *devicesView = [devicesController view];
  [self resizeWindowWithViewFrame:[devicesView frame]];
  [contentView setSubviews:[NSArray arrayWithObject:devicesView]];
}

- (void)resizeWindowWithViewFrame:(NSRect)newFrame
{
  CGRect windowFrame = [[self window] frame];
  CGRect viewFrame = [[[self window] contentView] frame];
  CGFloat titleBarHeight = CGRectGetHeight(windowFrame) - CGRectGetHeight(viewFrame);
  CGFloat x = CGRectGetMinX(windowFrame);
  CGFloat y = CGRectGetMinY(windowFrame) + titleBarHeight;
  CGFloat width = CGRectGetWidth(newFrame);
  CGFloat height = CGRectGetHeight(newFrame) + titleBarHeight;
  CGRect newWindowFrame = CGRectMake(x, y, width, height);
  [[self window] setFrame:newWindowFrame display:YES animate:YES];
}

@end