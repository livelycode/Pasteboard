#import <Foundation/Foundation.h>
#import "Cloudboard.h"
#import "HTTPConnection.h"

@class CBSyncController;

@interface MyHTTPConnection : HTTPConnection {
@private
  CBSyncController *syncController;
  NSMutableArray* postURLs;
}
- (id)initWithSyncController: (CBSyncController*)controller;
- (void)HTTPServer:(HTTPServer *)server didMakeNewConnection:(HTTPConnection *)connection;
- (void)HTTPConnection:(HTTPConnection *)connection didReceiveRequest:(CFHTTPMessageRef)request;

@end