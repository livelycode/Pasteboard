#import "CBHTTPConnectioniOS.h"

@implementation CBHTTPConnection(iOSOverridden)

- (id)initWithAsyncSocket:(GCDAsyncSocket *)newSocket configuration:(HTTPConfig *)aConfig {
  self = [super initWithAsyncSocket:newSocket configuration:aConfig];
  if (self != nil) {
    CBApplicationController* appController = [[UIApplication sharedApplication] delegate];
    syncController = [appController syncController];
  }
  return self;
}

@end
