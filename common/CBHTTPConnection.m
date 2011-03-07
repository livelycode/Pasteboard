#import "CBHTTPConnection.h"
#import "HTTPMessage.h"
#import "HTTPDataResponse.h"
#import "DDNumber.h"

@implementation CBHTTPConnection

@end

@implementation CBHTTPConnection(Private)

- (NSData*)handlePOSTWithPath:(NSString*)path body:(NSData*)body {
  NSData* responseData;
  NSLog(@"got path: %@", path);
  BOOL match = NO;
  if([path isEqual:@"register"]) {
    match = YES;
    NSString* clientName = [[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] autorelease];
    dispatch_async(dispatch_get_main_queue(), ^{
      [syncController registrationRequestFrom:clientName];
    });
    responseData = [@"ok" dataUsingEncoding: NSUTF8StringEncoding];
  }
  if([path isEqual:@"confirm"]) {
    match = YES;
    NSString* clientName = [[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] autorelease];
    dispatch_async(dispatch_get_main_queue(), ^{
      NSLog(@"confirm in dispatch queue");
      [syncController registrationConfirmationFrom:clientName];
    });
    responseData = [@"ok" dataUsingEncoding: NSUTF8StringEncoding];
  }
  // Set clipboard item at URL
  if([postURLs containsObject: path]) {
    match = YES;
    NSInteger itemIndex = [path intValue];
    NSAttributedString* itemString = [[NSAttributedString alloc] initWithString: 
                                      [NSKeyedUnarchiver unarchiveObjectWithData:body]];
    CBItem* item = [[CBItem alloc] initWithString: itemString];
    dispatch_async(dispatch_get_main_queue(), ^{
      [syncController receivedRemoteItem:item atIndex:itemIndex];
    });
    responseData = [@"ok" dataUsingEncoding: NSUTF8StringEncoding];
  }
  if([path isEqualToString:@"add"]) {
    match = YES;
    NSAttributedString* itemString = [[NSAttributedString alloc] initWithString: 
                                      [NSKeyedUnarchiver unarchiveObjectWithData:body]];
    CBItem* item = [[CBItem alloc] initWithString: itemString];
    dispatch_async(dispatch_get_main_queue(), ^{
      [syncController receivedAddedRemoteItem:item];
    });
    responseData = [@"ok" dataUsingEncoding: NSUTF8StringEncoding];
  }
  if(match == NO) {
    responseData = [@"invalid" dataUsingEncoding: NSUTF8StringEncoding];
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

- (void)prepareForBodyWithSize:(UInt64)contentLength {
  dataStartIndex = 0;
  if (multipartData == nil ) multipartData = [[NSMutableArray alloc] init];   //jlz
  postHeaderOK = FALSE ;
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
  NSString* newPath = [path substringFromIndex:1];
  if ([method isEqualToString:@"POST"]) {
    NSString *postStr = nil;
	NSData *postData = [request body];
    NSData* response = [self handlePOSTWithPath:newPath body:postData];
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