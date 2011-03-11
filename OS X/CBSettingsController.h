#import "Cocoa.h"
#import "CBSyncControllerProtocol.h"

@class CBMainWindowController;

@interface CBSettingsController : NSViewController {
@private
  CBMainWindowController* windowController;
  CBApplicationController* appController;
  CBSyncController* syncController;
  NSMutableArray *foundCloudboards;
  NSMutableArray *registeredClipboards;
  NSURL *devicesURL;
  IBOutlet NSButton* autoStartButton;
  IBOutlet NSButton* autoPasteButton;
  IBOutlet NSTableView *foundClipboardsView;
  IBOutlet NSTableView *registeredClipboardsView;
  IBOutlet NSButton *addButton;
  IBOutlet NSButton *removeButton;
  IBOutlet NSButton *backButton;
}
- (id)initWithFrame:(CGRect)aRect syncController:(CBSyncController*)syncController;
- (void)setWindowController:(CBMainWindowController *)aController;
@end

@interface CBSettingsController(Actions)
- (IBAction)addDevice:(id)sender;
- (IBAction)removeDevice:(id)sender;
- (IBAction)autoPasteCheckboxChanged:(id)sender;
- (IBAction)autoStartCheckboxChanged:(id)sender;
- (IBAction)back:(id)sender;
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