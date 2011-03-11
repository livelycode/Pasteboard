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

@end

@implementation CBApplicationController(Delegation)

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [self loadSettings];
  windowController = [[CBMainWindowController alloc] initWithFrontView:nil backView:nil];
  clipboardController = [windowController clipboardController];
  hotKey = [[CBHotKeyObserver alloc] init];
  [hotKey setDelegate:windowController];
  [self initPasteboardObserver];
}

- (void)systemPasteboardDidChange {
  CBItem* newItem = [self currentPasteboardItem];
  if(newItem) {
    if ([clipboardController clipboardContainsItem:newItem] == NO) {
      [clipboardController addItem:newItem syncing:YES];
    }
  }
}
@end

@implementation CBApplicationController(Private)

- (CBItem*)currentPasteboardItem {
  NSString* copyString = [[NSPasteboard generalPasteboard] stringForType:(NSString*)kUTTypeUTF8PlainText];
  return [[CBItem alloc] initWithString:copyString];
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
  NSMutableDictionary* settings = [[NSMutableDictionary alloc] init];
  [settings setValue:[NSNumber numberWithBool:NO] forKey:@"KeepAlive"];
  [settings setValue:@"Cloudboard" forKey:@"Label"];
  [settings setValue:[NSNumber numberWithBool:NO] forKey:@"OnDemand"];
  [settings setValue:[NSNumber numberWithBool:autoStart] forKey:@"RunAtLoad"];
  NSString* executablePath = [[NSBundle mainBundle] executablePath];
  NSString* programArgs = [[NSArray alloc] initWithObjects:executablePath, nil];
  [settings setValue: programArgs forKey:@"ProgramArguments"];
  NSURL* plistURL = [[NSURL alloc] initFileURLWithPath:[@"~/Library/LaunchAgents/Cloudboard.plist" stringByExpandingTildeInPath]];
  [settings writeToURL:plistURL atomically:YES];
}

@end