#import "Cloudboard.h"

@implementation CBDevicesController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    foundClipboards = [NSMutableArray array];
    [foundClipboards addObject:@"foo"];
  }
  return self;
}

@end

@implementation CBDevicesController(Delegation)

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
  return [foundClipboards count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
  id object = nil;
  if (aTableView == foundClipboardsView) {
    object = @"foo";
  }
  if (aTableView == registeredClipboardsView) {
    object = @"bar";
  }
  return object;
}

@end