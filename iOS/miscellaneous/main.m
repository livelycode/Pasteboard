#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
  NSLog(@"yes1");
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  int retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate");
  [pool release];
  return retVal;
}