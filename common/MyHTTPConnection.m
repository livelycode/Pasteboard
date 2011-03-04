#import "MyHTTPConnection.h"
#import "HTTPMessage.h"
#import "HTTPDataResponse.h"
#import "DDNumber.h"
#import "HTTPLogging.h"

// Log levels : off, error, warn, info, verbose
// Other flags: trace
static const int httpLogLevel = HTTP_LOG_LEVEL_WARN; // | HTTP_LOG_FLAG_TRACE;


/**
 * All we have to do is override appropriate methods in HTTPConnection.
**/

@implementation MyHTTPConnection


//old methods
- (id)initWithSyncController:(CBSyncController *)controller
{
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  syncController = controller;
  postURLs = [NSMutableArray array];
  for(NSInteger i = 0; i<8 ; i++) {
    [postURLs addObject: [[NSNumber numberWithInt: i] stringValue]];
  }
  return self;
}

- (void)HTTPConnection:(HTTPConnection *)connection didReceiveRequest:(CFHTTPMessageRef) message {
  NSString* method = [(NSString*) CFHTTPMessageCopyRequestMethod(message) autorelease];
  NSURL* url = [(NSURL*) CFHTTPMessageCopyRequestURL(message) autorelease];
  NSString* path = [[url path] substringFromIndex: 1];
  NSLog(@"Got path: %@", path);
  NSLog(@"method: %@", method);
  NSString* host = [[[NSString alloc] initWithData:[connection peerAddress] encoding:NSUTF8StringEncoding] autorelease];
  if ([method isEqual:@"GET"]) {
    NSData *itemData;
    itemData = [@"test data" dataUsingEncoding: NSUTF8StringEncoding];
    CFHTTPMessageRef response = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, NULL, kCFHTTPVersion1_1); // OK
    CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Content-Length", (CFStringRef)[NSString stringWithFormat:@"%d", [itemData length]]);
    CFHTTPMessageSetBody(response, (CFDataRef)itemData);
    [request setResponse:response];
    CFRelease(response);
  }
  if ([method isEqual:@"POST"]) {
    NSData* responseData;
    NSData* body = (NSData*) CFHTTPMessageCopyBody(message);
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
    CFHTTPMessageRef response = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, NULL, kCFHTTPVersion1_1);
    CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Content-Length", (CFStringRef)[NSString stringWithFormat:@"%d", [responseData length]]);
    CFHTTPMessageSetBody(response, (CFDataRef)responseData);
    [request setResponse:response];
    CFRelease(response);
  }
  return;
}

//end old methods

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path
{
	HTTPLogTrace();
	
	// Add support for POST
	
	if ([method isEqualToString:@"POST"])
	{
		if ([path isEqualToString:@"/post.html"])
		{
			// Let's be extra cautious, and make sure the upload isn't 5 gigs
			
			return requestContentLength < 50;
		}
	}
	
	return [super supportsMethod:method atPath:path];
}

- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path
{
	HTTPLogTrace();
	
	// Inform HTTP server that we expect a body to accompany a POST request
	
	if([method isEqualToString:@"POST"])
		return YES;
	
	return [super expectsRequestBodyFromMethod:method atPath:path];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
	HTTPLogTrace();
	
	if ([method isEqualToString:@"POST"] && [path isEqualToString:@"/post.html"])
	{
		HTTPLogVerbose(@"%@[%p]: postContentLength: %qu", THIS_FILE, self, requestContentLength);
		
		NSString *postStr = nil;
		
		NSData *postData = [request body];
		if (postData)
		{
			postStr = [[[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding] autorelease];
		}
		
		HTTPLogVerbose(@"%@[%p]: postStr: %@", THIS_FILE, self, postStr);
		
		// Result will be of the form "answer=..."
		
		int answer = [[postStr substringFromIndex:7] intValue];
		
		NSData *response = nil;
		if(answer == 10)
		{
			response = [@"<html><body>Correct<body></html>" dataUsingEncoding:NSUTF8StringEncoding];
		}
		else
		{
			response = [@"<html><body>Sorry - Try Again<body></html>" dataUsingEncoding:NSUTF8StringEncoding];
		}
		
		return [[[HTTPDataResponse alloc] initWithData:response] autorelease];
	}
	
	return [super httpResponseForMethod:method URI:path];
}

- (void)prepareForBodyWithSize:(UInt64)contentLength
{
	HTTPLogTrace();
	
	// If we supported large uploads,
	// we might use this method to create/open files, allocate memory, etc.
}

- (void)processDataChunk:(NSData *)postDataChunk
{
	HTTPLogTrace();
	
	// Remember: In order to support LARGE POST uploads, the data is read in chunks.
	// This prevents a 50 MB upload from being stored in RAM.
	// The size of the chunks are limited by the POST_CHUNKSIZE definition.
	// Therefore, this method may be called multiple times for the same POST request.
	
	BOOL result = [request appendData:postDataChunk];
	if (!result)
	{
		HTTPLogError(@"%@[%p]: %@ - Couldn't append bytes!", THIS_FILE, self, THIS_METHOD);
	}
}

@end
