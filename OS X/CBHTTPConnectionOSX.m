#import "CBHTTPConnectionOSX.h"

@implementation CBHTTPConnection(iOSOverridden)

- (id)initWithAsyncSocket:(GCDAsyncSocket *)newSocket configuration:(HTTPConfig *)aConfig {
  self = [super initWithAsyncSocket:newSocket configuration:aConfig];
  if (self != nil) {
    NSMutableArray* postURLsTemp = [NSMutableArray array];
    for(NSInteger i = 0; i<8 ; i++) {
      [postURLsTemp addObject: [[NSNumber numberWithInteger: i] stringValue]];
    }
    postURLs = [NSArray arrayWithArray: postURLsTemp];
    CBApplicationController* appController = [[NSApplication sharedApplication] delegate];
    syncController = [appController syncController];
  }
  return self;
}

@end
