#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  NSString* appControllerName;
  if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    appControllerName = @"CBApplicationController_iPad";
  } else {
    appControllerName = @"CBApplicationController_iPhone";
  }
  int retVal = UIApplicationMain(argc, argv, nil, appControllerName);
  [pool release];
  return retVal;
}