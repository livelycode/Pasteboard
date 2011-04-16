#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "CBApplicationController.h"

int main(int argc, char *argv[]) {
  NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
  CBApplicationController *delegate = [[[CBApplicationController alloc] init] autorelease];
  NSApplication *app = [NSApplication sharedApplication];
  [app setDelegate:delegate];
  [app run];
  [pool drain];
  return EXIT_SUCCESS;
}