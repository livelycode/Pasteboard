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
  
  if ([method isEqual:@"GET"]) {
    // Get clipboard item at URL
    NSURL *itemURL;
    
    NSData *itemData = [NSData dataWithContentsOfURL:itemURL];
    CFHTTPMessageRef response = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, NULL, kCFHTTPVersion1_1); // OK
    CFHTTPMessageSetHeaderFieldValue(response, (CFStringRef)@"Content-Length", (CFStringRef)[NSString stringWithFormat:@"%d", [itemData length]]);
    [request setResponse:response];
    CFRelease(response);
  }
  if ([method isEqual:@"POST"]) {
    NSData* itemData = (NSData*) CFHTTPMessageCopyBody(message);
    /* Set clipboard item at URL
     
    */
    CFHTTPMessageRef response = CFHTTPMessageCreateResponse(kCFAllocatorDefault, 200, NULL, kCFHTTPVersion1_1); // OK
    [request setResponse:response];
    CFRelease(response);
  }
  return;
}
@end
