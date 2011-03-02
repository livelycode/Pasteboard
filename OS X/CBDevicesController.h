#import "Cocoa.h"

@interface CBDevicesController : NSViewController {
@private
  NSMutableArray *foundClipboards;
  NSMutableArray *registeredClipboards;
  NSURL *devicesURL;
  IBOutlet NSTableView *foundClipboardsView;
  IBOutlet NSTableView *registeredClipboardsView;
  IBOutlet NSButton *addButton;
  IBOutlet NSButton *removeButton;
}

- (IBAction)addDevice:(id)sender;

- (IBAction)removeDevice:(id)sender;

@end

@interface CBDevicesController(Overridden)

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle;

@end

@interface CBDevicesController(Delegation) <NSTableViewDataSource, NSTableViewDelegate>

- (void)awakeFromNib;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;

@end