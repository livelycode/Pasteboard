#import "Cloudboard.h"

@implementation CBApplicationController

- (void)initClipboards {
  CGRect mainFrame = [[UIScreen mainScreen] bounds];
  window = [[UIWindow alloc] initWithFrame:mainFrame];
  [window makeKeyAndVisible];
  syncingClipboardController = [[CBClipboardController alloc] initWithDelegate:self];
}


- (void)addSubview: (UIView*) subView {
  [window addSubview:subView];
}

- (CBClipboardController*)clipboardController {
  return syncingClipboardController;
}

- (CBSyncController*)syncController {
  return [syncingClipboardController syncController];
}

- (CBItem*)currentPasteboardItem {
  NSString* value = [[UIPasteboard generalPasteboard] valueForPasteboardType:(NSString*)kUTTypeUTF8PlainText];
  NSLog(@"pasted: %@", value);
  if(value != nil) {
    CBItem* item = [[CBItem alloc] initWithString:value];
    return item;
  }
  return nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self initClipboards];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  NSLog(@"moved to background");
  [syncingClipboardController stopSyncing];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  NSLog(@"entering foreground");
  [syncingClipboardController startSyncing];
}


- (void)applicationWillTerminate:(UIApplication *)application {
  NSLog(@"will terminate");
  [syncingClipboardController stopSyncing];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
  /*
   Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
   */
}

@end

@implementation CBApplicationController(Delegation)
//CBSyncControllerDelegate
- (void)clientAsksForRegistration:(NSString *)clientName {
  NSLog(@"client asks for registration: %@", clientName);
}
@end