#import "Cloudboard.h"

@implementation CBApplicationController

- (CBClipboardController*)clipboardController {
  return clipboardController;
}

- (CBSyncController*)syncController {
  return [clipboardController syncController];
}

- (CBItem*)currentPasteboardItem {
  NSString* value = [[UIPasteboard generalPasteboard] valueForPasteboardType:(NSString*)kUTTypeUTF8PlainText];
  if(value != nil) {
    CBItem* item = [CBItem itemWithString:value];
    return item;
  }
  return nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  CGRect mainFrame = [[UIScreen mainScreen] bounds];
  window = [[UIWindow alloc] initWithFrame:mainFrame];
  [window makeKeyAndVisible];
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
  [clipboardController stopSyncing];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  [clipboardController startSyncing];
}


- (void)applicationWillTerminate:(UIApplication *)application {
  [clipboardController stopSyncing];
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
}
@end