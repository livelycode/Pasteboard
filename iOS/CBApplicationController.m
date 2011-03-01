#import "Cloudboard.h"

@implementation CBApplicationController

- (void)initClipboards {
  CGRect mainFrame = [[UIScreen mainScreen] bounds];
  window = [[UIWindow alloc] initWithFrame:mainFrame];
  CGFloat screenHeight = CGRectGetHeight(mainFrame);
  CGFloat screenWidth = CGRectGetWidth(mainFrame);
  CGFloat marginSide = 90;
  CGFloat marginBottom = 90;
  CGFloat clipboardHeight = screenHeight - (2 * marginBottom);
  CGFloat clipboardWidth = (screenWidth - (3 * marginSide)) / 2;
  CGRect frame = CGRectMake(screenWidth - marginSide - clipboardWidth, marginBottom, clipboardWidth, clipboardHeight);
  syncingClipboardController = [[CBClipboardController alloc] initWithFrame: frame viewController: self];
}


- (void)addSubview: (UIView*) subView {
  [window addSubview:subView];
}

- (void)startSyncing {
  syncController = [[CBSyncController alloc] initWithClipboardController: syncingClipboardController];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSLog(@"didFinishLaunching");
  [self initClipboards];
  [self startSyncing];
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


- (void)applicationWillTerminate:(UIApplication *)application
{
  /*
   Called when the application is about to terminate.
   */
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