#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "CBApplicationController.h"

int main(int argc, char *argv[])
{
    CBApplicationController *delegate = [[CBApplicationController alloc] init];
    NSApplication *app = [NSApplication sharedApplication];
    [app setDelegate:delegate];
    [app run];
    return EXIT_SUCCESS;
}