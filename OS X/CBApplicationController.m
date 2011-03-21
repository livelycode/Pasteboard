#import "Cloudboard.h"

@implementation CBApplicationController

-(void) initPasteboardObserver {
  pasteboardObserver = [[CBPasteboardObserver alloc] init];
  [pasteboardObserver setDelegate:self];
  [pasteboardObserver observeWithTimeInterval:0.1];
}

- (CBSyncController*)syncController {
  return [clipboardController syncController];
}

- (BOOL)autoPaste {
  return autoPaste;
}

- (BOOL)autoStart {
  return autoStart;
}

- (void)setAutoPaste:(BOOL)newAutoPaste {
  autoPaste = newAutoPaste;
  [self updateSettings];
}

- (void)setAutoStart:(BOOL)newAutoStart {
  autoStart = newAutoStart;
  [self updateSettings];
  [self updateLaunchd];
}

- (NSString*)hotkey {
  return @"Alt+Tab";
}

- (void)setHotkey:(NSUInteger)charId withModifier:(NSUInteger)modifier {
  
}

- (void)dealloc {
  [pasteboardObserver release];		
  [hotKey release];
  [clipboardController release];
  [windowController release];
  [syncController release];
  [statusItem release];
  [super dealloc];
}

@end

@implementation CBApplicationController(Actions)

- (IBAction)showPasteboard:(id)sender {
  [windowController toggleVisibility];
}

- (IBAction)quitApplication:(id)sender {
  [[NSApplication sharedApplication] terminate:sender];
}

@end

@implementation CBApplicationController(Delegation)

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [self loadSettings];
  windowController = [[CBMainWindowController alloc] initWithFrontView:nil backView:nil];
  clipboardController = [[windowController clipboardController] retain];
  hotKey = [[CBHotKeyObserver alloc] initAltTab];
  [hotKey setDelegate:windowController];
  [self initPasteboardObserver];
  [self activateStatusMenu];
}

- (void)pasteItem {
  CBItem* newItem = [self currentPasteboardItem];
  if(newItem) {
    if ([clipboardController clipboardContainsItem:newItem] == NO) {
      [clipboardController addItem:newItem syncing:YES];
    }
  }
}

- (void)systemPasteboardDidChange {
  if(autoPaste) {
    [self pasteItem];
  }
}

- (void)applicationWillTerminate:(NSNotification *)notification {
  [clipboardController persistClipboard];
}
@end

@implementation CBApplicationController(Private)

- (CBItem*)currentPasteboardItem {
  NSString* copyString = [[NSPasteboard generalPasteboard] stringForType:(NSString*)kUTTypeUTF8PlainText];
  if(copyString) {
    return [CBItem itemWithString:copyString];
  } else {
    return nil;
  }
}

- (void)loadSettings {
  NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
  autoStart = [userDefaults boolForKey:@"AutoStart"];
  autoPaste = [userDefaults boolForKey:@"AutoPaste"];
}

- (void)updateSettings {
  NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setBool:autoStart forKey:@"AutoStart"];
  [userDefaults setBool:autoPaste forKey:@"AutoPaste"];
  [userDefaults synchronize];
}

- (void)updateLaunchd {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *folder = [@"~/Library/LaunchAgents/" stringByExpandingTildeInPath];  
  if ([fileManager fileExistsAtPath: folder] == NO) {
    [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL];
  }
  NSMutableDictionary* settings = [NSMutableDictionary dictionary];
  [settings setValue:[NSNumber numberWithBool:NO] forKey:@"KeepAlive"];
  [settings setValue:@"Cloudboard" forKey:@"Label"];
  [settings setValue:[NSNumber numberWithBool:NO] forKey:@"OnDemand"];
  [settings setValue:[NSNumber numberWithBool:autoStart] forKey:@"RunAtLoad"];
  NSString* executablePath = [[NSBundle mainBundle] executablePath];
  NSString* programArgs = [NSArray arrayWithObjects:executablePath, nil];
  [settings setValue: programArgs forKey:@"ProgramArguments"];
  NSURL* plistURL = [[NSURL alloc] initFileURLWithPath:[@"~/Library/LaunchAgents/Cloudboard.plist" stringByExpandingTildeInPath]];
  [settings writeToURL:plistURL atomically:YES];
}

- (void)activateStatusMenu {
  [NSBundle loadNibNamed:@"menu" owner:self];
  NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
  statusItem = [[statusBar statusItemWithLength:NSVariableStatusItemLength] retain];
  [statusItem setImage:[NSImage imageNamed:@"StatusItem"]];
  [statusItem setAlternateImage:[NSImage imageNamed:@"StatusItemHighlighted"]];
  [statusItem setHighlightMode:YES];
  [statusItem setMenu:statusBarMenu];
}

@end