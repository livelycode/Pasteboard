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
  NSUInteger index = [foundClipboardsView selectedRow];
  id device = [foundClipboards objectAtIndex:index];
  [registeredClipboards addObject:device];
  [registeredClipboardsView reloadData];
}

- (IBAction)removeDevice:(id)sender {
  NSUInteger index = [registeredClipboardsView selectedRow];
  [registeredClipboards removeObjectAtIndex:index];
  [registeredClipboardsView reloadData];
}

- (void)awakeFromNib {
  [addButton setEnabled:NO];
  [removeButton setEnabled:NO];
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

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
  if ([aNotification object] == foundClipboardsView) {
    if ([foundClipboardsView numberOfSelectedRows] != 0) {
      [addButton setEnabled:YES];
    }
    else {
      [addButton setEnabled:NO];
    }
  }
  
  if ([aNotification object] == registeredClipboardsView) {
    if ([registeredClipboardsView numberOfSelectedRows] != 0) {
      [removeButton setEnabled:YES];
    }
    else {
      [removeButton setEnabled:NO];
    }
  }
}

@end