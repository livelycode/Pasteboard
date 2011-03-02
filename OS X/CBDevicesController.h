#import "Cocoa.h"

@interface CBDevicesController : NSViewController {
@private
  NSMutableArray *foundClipboards;
  IBOutlet NSTableView *foundClipboardsView;
  IBOutlet NSTableView *registeredClipboardsView;
}

@end

@interface CBDevicesController(Delegation) <NSTableViewDataSource, NSTableViewDelegate>

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;

@end