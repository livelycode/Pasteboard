#import "CBHTTPConnectionOSX.h"

@implementation CBHTTPConnection(iOSOverridden)

- (id)initWithAsyncSocket:(GCDAsyncSocket *)newSocket configuration:(HTTPConfig *)aConfig {
  self = [super init];
  if (self != nil) {
    NSMutableArray* postURLsTemp = [NSMutableArray array];
    for(NSInteger i = 0; i<8 ; i++) {
      [postURLs addObject: [[NSNumber numberWithInt: i] stringValue]];
    }
    postURLs = [NSArray arrayWithArray: postURLsTemp];
    syncController = [[[NSApplication sharedApplication] delegate] syncController];
  }
  return self;
}

@end
