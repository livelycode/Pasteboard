//
//  RemoteCloudboard.m
//  cloudboard
//
//  Created by Mirko on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBRemoteCloudboard.h"


@implementation CBRemoteCloudboard

- (id)initWithURL:(NSURL*)baseURL
{
    self = [super init];
    if (self) {
      url = baseURL;
    }
    return self;
}

- (id)initWithHost:(NSString*)host port:(NSInteger)port
{
  NSMutableString *URLString = [NSMutableString string];
  [URLString appendString:@"http://"];
  [URLString appendString:host];
  [URLString appendString:@":"];
  [URLString appendString:[[NSNumber numberWithUnsignedInteger:port] stringValue]];
  return [self initWithURL:[NSURL URLWithString:URLString]];
}

- (void)addClient:(CBSyncController*)client {
  NSURL *requestURL = [url URLByAppendingPathComponent:@"register"];
  NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:requestURL];
  [URLRequest setHTTPMethod:@"POST"];
  [URLRequest setHTTPBody:[[[client URL] absoluteString] dataUsingEncoding: NSUTF8StringEncoding]];
  NSURLResponse *URLResponse = nil;
  NSError *receivedError = nil;
  NSData *receivedData = [NSURLConnection sendSynchronousRequest:URLRequest
                                               returningResponse:&URLResponse
                                                           error:&receivedError];
  NSLog(@"registration response: %@", [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease]);
  [client addClient: self];
}

- (void)syncItem:(CBItem*)item atIndex:(NSUInteger)index {
  NSURL *requestURL = [url URLByAppendingPathComponent:[[NSNumber numberWithInt: index] stringValue]];
  NSData* archivedItem = [NSArchiver archivedDataWithRootObject: [item string]];
  NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:requestURL];
  [URLRequest setHTTPMethod:@"POST"];
  [URLRequest setHTTPBody:archivedItem];
  NSURLResponse *URLResponse = nil;
  NSError *receivedError = nil;
  NSData *receivedData = [NSURLConnection sendSynchronousRequest:URLRequest
                                               returningResponse:&URLResponse
                                                           error:&receivedError];
  NSLog(@"sync response: %@", [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease]);
}

- (NSURL*)URL {
  return url;
}
- (void)dealloc
{
    [super dealloc];
}

@end
