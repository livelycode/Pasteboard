#import "Cloudboard.h"

@implementation CBPreferencesController(Private)

- (void)setVisibleView:(NSView *)aView animated:(BOOL)resizeAnimated {
  NSWindow *window = [self window];
  NSView *contentView = [window contentView];
  CGRect windowFrame = [window frame];
  CGRect viewFrame = [contentView frame];
  CGRect newFrame = [aView frame];
  CGFloat titleBarHeight = CGRectGetHeight(windowFrame) - CGRectGetHeight(viewFrame);
  CGFloat differenceHeight = CGRectGetHeight(viewFrame) - CGRectGetHeight(newFrame);
  CGFloat x = CGRectGetMinX(windowFrame);
  CGFloat y = CGRectGetMinY(windowFrame) + differenceHeight;
  CGFloat width = CGRectGetWidth(newFrame);
  CGFloat height = CGRectGetHeight(newFrame) + titleBarHeight;
  CGRect newWindowFrame = CGRectMake(x, y, width, height);
  [window setContentView:intermediateView];
  [window setFrame:newWindowFrame display:YES animate:resizeAnimated];
  [window setContentView:aView];
}

@end

@implementation CBPreferencesController

- (void)windowDidLoad {
  [super windowDidLoad];
  [[self window] setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];
  [[self window] setLevel:NSStatusWindowLevel];
  generalController = [[CBGeneralController alloc] initWithNibName:@"general" bundle:nil];
  devicesController = [[CBDevicesController alloc] initWithNibName:@"devices" bundle:nil];
  intermediateView = [[NSView alloc] init];
  NSView *generalView = [generalController view];
  [self setVisibleView:generalView animated:NO];
} 

- (IBAction)showGeneralView:(id)sender {
  NSView *generalView = [generalController view];
  [self setVisibleView:generalView animated:YES];
}

- (IBAction)showDevicesView:(id)sender {
  NSView *devicesView = [devicesController view];
  [self setVisibleView:devicesView animated:YES];
}

@end