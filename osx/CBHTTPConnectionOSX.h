#import "CBHTTPConnection.h"

@class GCDAsyncSocket, HTTPConfig;

@interface CBHTTPConnection(iOSOverriden)
- (id)initWithAsyncSocket:(GCDAsyncSocket *)newSocket configuration:(HTTPConfig *)aConfig;
@end