#import "Cloudboard.h"

@implementation CBDevicesController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    foundClipboards = [NSMutableArray array];
    [foundClipboards addObject:@"foo"];
    registeredClipboards = [NSMutableArray array];
    [registeredClipboards addObject:@"bar"];
  }
  return self;
}

- (IBAction)addDevice:(id)sender {
  NSLog(@"add");
}

- (IBAction)removeDevice:(id)sender {
  NSLog(@"remove");
}

@end

@implementation CBDevicesController(Delegation)

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
  NSUInteger count = 0;
  if (aTableView == foundClipboardsView) {
    count = [foundClipboards count];
  }
  if (aTableView == registeredClipboardsView) {
    count = [registeredClipboards count];
  }
  return count;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
  id object = nil;
  if (aTableView == foundClipboardsView) {
    object = [foundClipboards objectAtIndex:rowIndex];
  }
  if (aTableView == registeredClipboardsView) {
    object = [registeredClipboards objectAtIndex:rowIndex];
  }
  return object;
}

@end