#import <Foundation/Foundation.h>
#import "Cloudboard.h"
#import "HTTPConnection.h"

@class CBSyncController;

@interface CBHTTPConnection : HTTPConnection {
@private
  CBSyncController *syncController;
  NSMutableArray* postURLs;
  int dataStartIndex;
  NSMutableArray* multipartData;
  BOOL postHeaderOK;
}

@end

@interface CBHTTPConnection(Private)
- (NSData*)handlePOSTWithPath:(NSString*)path body:(NSData*)body;
@end

@interface CBHTTPConnection(Overridden)
- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path;
- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path;
- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path;
- (void)processDataChunk:(NSData *)postDataChunk;
@end