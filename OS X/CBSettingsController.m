#import "Cloudboard.h"


@implementation CBSettingsController(Actions)

- (IBAction)addDevice:(id)sender {
  NSUInteger index = [foundClipboardsView selectedRow];
  NSString* device = [foundCloudboards objectAtIndex:index];
  [registeredClipboards addObject:device];
  [foundCloudboards removeObject:device];
  [foundClipboardsView reloadData];
  [registeredClipboardsView reloadData];
  [syncController addClientToSearch:device];
}

- (IBAction)removeDevice:(id)sender {
  NSUInteger index = [registeredClipboardsView selectedRow];
  NSString* device = [registeredClipboards objectAtIndex:index];
  [registeredClipboards removeObjectAtIndex:index];
  [foundCloudboards addObject:device];
  [foundClipboardsView reloadData];
  [registeredClipboardsView reloadData];
  [syncController removeClientToSearch:device];
}

- (IBAction)back:(id)sender {
NSLog(@"bar");
  [windowController showFront];
}

@end

@implementation CBSettingsController

- (id)initWithFrame:(CGRect)aRect syncController:(CBSyncController*) aSyncController; {
  self = [super initWithNibName:@"settings" bundle:nil];
  if(self != nil) {
    [[self view] setFrame:aRect];
    syncController = aSyncController;
    [syncController addDelegate:self];
    foundCloudboards = [NSMutableArray arrayWithArray:[syncController clientsVisible]];
    registeredClipboards = [NSMutableArray arrayWithArray:[syncController clientsToSearch]];
    for(NSString*client in registeredClipboards) {
      [foundCloudboards removeObject:client];
    }
    if (registeredClipboards == nil) {
      registeredClipboards = [NSMutableArray array];
    }
  }
  return self;
}

- (void)setWindowController:(CBMainWindowController *)aController {
  windowController = aController;
}

@end

@implementation CBSettingsController(Delegation)

- (void)awakeFromNib {
  [addButton setEnabled:NO];
  [removeButton setEnabled:NO];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
  NSUInteger count = 0;
  if (aTableView == foundClipboardsView) {
    count = [foundCloudboards count];
  }
  if (aTableView == registeredClipboardsView) {
    count = [registeredClipboards count];
  }
  return count;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
  id object = nil;
  if (aTableView == foundClipboardsView) {
    object = [foundCloudboards objectAtIndex:rowIndex];
  }
  if (aTableView == registeredClipboardsView) {
    object = [registeredClipboards objectAtIndex:rowIndex];
  }
  NSString* substring = [object substringFromIndex:10];
  return substring;
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

//CBSyncControllerDelegate
- (void)clientBecameVisible:(NSString*)clientName {
  if(([foundCloudboards containsObject:clientName] == NO) && ([registeredClipboards containsObject:clientName] == NO)) {
    [foundCloudboards addObject:clientName];
    [foundClipboardsView reloadData];
  }
}

- (void)clientBecameInvisible:(NSString*)clientName {
  NSLog(@"client invisible %@", clientName);
  if([foundCloudboards containsObject:clientName]) {
    [foundCloudboards removeObject:clientName];
    [foundClipboardsView reloadData];
  }
}

- (void)clientConnected:(NSString*)clientName {
  NSLog(@"client connected %@", clientName);
}

- (void)clientDisconnected:(NSString*)clientName {
  NSLog(@"client disconnected %@", clientName);
}

- (void)clientConfirmed:(NSString*)clientName {
  NSLog(@"client confirmed %@", clientName);
}

@end