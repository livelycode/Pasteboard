#import "CBHTTPConnection.h"
#import "HTTPMessage.h"
#import "HTTPDataResponse.h"
#import "DDNumber.h"

@implementation CBHTTPConnection

@end

@implementation CBHTTPConnection(Private)

- (NSData*)handlePOSTWithPath:(NSString*)path body:(NSData*)body {
  NSData* responseData;
  if([path isEqual:@"register"]) {
    NSString* clientName = [[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] autorelease];
    CBRemoteCloudboard* newClient = [[CBRemoteCloudboard alloc] initWithURL: [NSURL URLWithString: clientName]];
    [syncController addClient:newClient];	
    responseData = [@"success" dataUsingEncoding: NSUTF8StringEncoding];
  } else {
    // Set clipboard item at URL
    if([postURLs containsObject: path]) {
      NSInteger itemIndex = [path intValue];
      NSAttributedString* itemString = [[NSAttributedString alloc] initWithString: 
                                        [NSKeyedUnarchiver unarchiveObjectWithData:body]];
      CBItem* item = [[CBItem alloc] initWithString: itemString];
      [syncController receivedItem:item atIndex:itemIndex];
      responseData = [@"success" dataUsingEncoding: NSUTF8StringEncoding];
    } else {
      responseData = [@"invalid" dataUsingEncoding: NSUTF8StringEncoding];
    }
  }
  return responseData;
}

@end

@implementation CBHTTPConnection(Overridden)

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path {
  // Add support for POST	
  if ([method isEqualToString:@"POST"])	{
    return YES;
  }	
  return [super supportsMethod:method atPath:path];
}

- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path {
  // Inform HTTP server that we expect a body to accompany a POST request
  if([method isEqualToString:@"POST"]) {
    return YES;    
  }
  return [super expectsRequestBodyFromMethod:method atPath:path];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
  if ([method isEqualToString:@"POST"]) {
    NSLog(@"got POST");
    NSString *postStr = nil;
	NSData *postData = [request body];
    NSData* response = [self handlePOSTWithPath:path body:postData];
	return [[[HTTPDataResponse alloc] initWithData:response] autorelease];
  }	else {
    NSLog(@"got GET request");
  }
}

- (void)processDataChunk:(NSData *)postDataChunk {
  // Remember: In order to support LARGE POST uploads, the data is read in chunks.
  // This prevents a 50 MB upload from being stored in RAM.
  // The size of the chunks are limited by the POST_CHUNKSIZE definition.
  // Therefore, this method may be called multiple times for the same POST request.
  BOOL result = [request appendData:postDataChunk];
  if (!result)	{
    NSLog(@"no result in post data");
  }
}

@end
