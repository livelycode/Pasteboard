//
//  HTTPConnectionDelegate.m
//  cloudboard
//
//  Created by Mirko on 2/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HTTPConnectionDelegate.h"
#import <CoreFoundation/CoreFoundation.h>

@implementation HTTPConnectionDelegate

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

- (void)dealloc
{
    [super dealloc];
}
- (void)HTTPServer:(HTTPServer *)server didMakeNewConnection:(HTTPConnection *)connection {

}
- (void)HTTPConnection:(HTTPConnection *)connection didReceiveRequest:(HTTPServerRequest *)request {
  CFHTTPMessageRef message = [request request];
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
        CBItem* item = [[CBItem alloc] initWithString: [NSKeyedUnarchiver unarchiveObjectWithData:body]];
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
@end
