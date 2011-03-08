#import "Cocoa.h"
#import "CBSyncControllerProtocol.h"

@interface CBSettingsController : NSViewController {
@private
  CBSyncController* syncController;
  NSMutableArray *foundClipboards;
  NSMutableArray *registeredClipboards;
  NSURL *devicesURL;
  IBOutlet NSTableView *foundClipboardsView;
  IBOutlet NSTableView *registeredClipboardsView;
  IBOutlet NSButton *addButton;
  IBOutlet NSButton *removeButton;
}

- (id)initWithSyncController:(CBSyncController*)sync;
- (IBAction)addDevice:(id)sender;

- (IBAction)removeDevice:(id)sender;

@end

@interface CBSettingsController(Overridden)

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle;

@end

@interface CBSettingsController(Delegation)
  <NSTableViewDataSource, NSTableViewDelegate, CBSyncControllerProtocol>

- (void)awakeFromNib;

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;

//CBSyncControllerDelegate
- (void)clientBecameVisible:(NSString*)clientName;
- (void)clientBecameInvisible:(NSString*)clientName;
- (void)clientConnected:(NSString*)clientName;
- (void)clientConfirmed:(NSString*)clientName;
@end