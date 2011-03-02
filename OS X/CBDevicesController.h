#import "Cocoa.h"

@interface CBDevicesController : NSViewController {
@private
  NSMutableArray *foundClipboards;
  IBOutlet NSTableView *foundClipboardsView;
  IBOutlet NSTableView *registeredClipboardsView;
  IBOutlet NSButton *addButton;
  IBOutlet NSButton *removeButton;
}

- (IBAction)addDevice:(id)sender;

- (IBAction)removeDevice:(id)sender;

@end

@interface CBDevicesController(Delegation) <NSTableViewDataSource, NSTableViewDelegate>

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;

@end