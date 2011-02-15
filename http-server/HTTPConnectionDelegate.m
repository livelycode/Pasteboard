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

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
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
  NSLog(@"Got url: %@", url);
  NSLog(@"method: %@", method);
  if ([method isEqual:@"GET"]) {
    /* Get clipboard item at URL
    NSURL *itemURL;
    NSData *itemData = [NSData dataWithContentsOfURL:itemURL];
    */
    NSData *itemData = [@"test data" dataUsingEncoding: NSUTF8StringEncoding];
    CFHTTPMessageRef response = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, NULL, kCFHTTPVersion1_1); // OK
    CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Content-Length", (CFStringRef)[NSString stringWithFormat:@"%d", [itemData length]]);
    CFHTTPMessageSetBody(response, (CFDataRef)itemData);
    [request setResponse:response];
    CFRelease(response);
  }
  if ([method isEqual:@"POST"]) {
    NSData* itemData = (NSData*) CFHTTPMessageCopyBody(message);
    /* Set clipboard item at URL
     
    */
    NSData *ok = [@"ok" dataUsingEncoding: NSUTF8StringEncoding];
    CFHTTPMessageRef response = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, NULL, kCFHTTPVersion1_1); // OK
    CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Content-Length", (CFStringRef)[NSString stringWithFormat:@"%d", [ok length]]);
    CFHTTPMessageSetBody(response, (CFDataRef)ok);
    [request setResponse:response];
    CFRelease(response);
  }
  return;
}
@end
