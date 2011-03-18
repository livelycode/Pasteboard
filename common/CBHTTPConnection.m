#import "CBHTTPConnection.h"
#import "HTTPMessage.h"
#import "HTTPDataResponse.h"
#import "DDNumber.h"

@implementation CBHTTPConnection

@end

@implementation CBHTTPConnection(Private)

- (NSData*)handlePOSTWithPath:(NSString*)path body:(NSData*)body {
  NSData* responseData;
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
      [syncController registrationConfirmationFrom:clientName];
    });
    responseData = [@"ok" dataUsingEncoding: NSUTF8StringEncoding];
  }
  // Set clipboard item at URL
  if([path isEqualToString:@"initialsync"]) {
    match = YES;
    NSString* plainString = [NSKeyedUnarchiver unarchiveObjectWithData:body];
    NSMutableArray* items = [NSMutableArray array];
    NSMutableArray* strings = [NSMutableArray arrayWithArray:[plainString componentsSeparatedByString:POST_SEPARATOR]];
    NSDate* lastChanged = [NSDate dateWithTimeIntervalSince1970:[[strings objectAtIndex:0] integerValue]];
    [strings removeObjectAtIndex:0];
    for(NSString* string in strings) {
      CBItem* item = [[[CBItem alloc] initWithString: string] autorelease];
      [items addObject: item];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      [syncController receivedRemoteItems:items changedDate:lastChanged];
    });
    responseData = [@"ok" dataUsingEncoding: NSUTF8StringEncoding];
  }
  if([path isEqualToString:@"add"]) {
    match = YES;
    CBItem* item = [[[CBItem alloc] initWithString: [NSKeyedUnarchiver unarchiveObjectWithData:body]] autorelease];
    dispatch_async(dispatch_get_main_queue(), ^{
      [syncController receivedAddedRemoteItem:item];
    });
    responseData = [@"ok" dataUsingEncoding: NSUTF8StringEncoding];
  }
  if([path isEqualToString:@"reset"]) {
    match = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
      [syncController receivedReset];
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
	NSData *postData = [request body];
    NSData* response = [self handlePOSTWithPath:newPath body:postData];
	return [[[HTTPDataResponse alloc] initWithData:response] autorelease];
  }	else {
    NSLog(@"got GET request");
    return [[[HTTPDataResponse alloc] init] autorelease];
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

- (void)dealloc {
  [syncController release];
  [multipartData release];
  [super dealloc];
}

@end
