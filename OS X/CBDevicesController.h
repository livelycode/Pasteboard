#import "Cocoa.h"

@interface CBDevicesController : NSViewController {
@private
  NSMutableArray *foundClipboards;
  NSMutableArray *registeredClipboards;
  IBOutlet NSTableView *foundClipboardsView;
  IBOutlet NSTableView *registeredClipboardsView;
  IBOutlet NSButton *addButton;
  IBOutlet NSButton *removeButton;
}

- (IBAction)addDevice:(id)sender;

- (IBAction)removeDevice:(id)sender;

- (void)awakeFromNib;

@end

@interface CBDevicesController(Delegation) <NSTableViewDataSource, NSTableViewDelegate>

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;

@end