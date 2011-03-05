//
//  RemoteCloudboard.m
//  cloudboard
//
//  Created by Mirko on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBRemoteCloudboard.h"


@implementation CBRemoteCloudboard

- (id)initWithService:(NSNetService*)aService syncController:(CBSyncController*)aSyncController
{
    self = [super init];
    if (self) {
      service = [aService retain];
      syncController = [aSyncController retain];
      confirmClient = NO;
      registerClient = NO;
    }
    return self;
}

- (void)registerAsClient {
  if(url) {
    [self sendRegistration];
  } else {
    registerClient = YES;
    [self resolveService];
  }}

- (void)confirmClient {
  if(url) {
    [self sendRegistrationConfirmation];
  } else {
    confirmClient = YES;
    [self resolveService];
  }
}

- (void)syncItem:(CBItem*)item atIndex:(NSUInteger)index {
  NSURL *requestURL = [url URLByAppendingPathComponent:[[NSNumber numberWithInt: index] stringValue]];
  NSData* archivedItem = [NSKeyedArchiver archivedDataWithRootObject: [[item string] string]];
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

- (NSString*)serviceName {
  return [service name];
}

- (BOOL)isEqual:(id)anObject {
  if([anObject respondsToSelector:@selector(serviceName)]) {
    if([[self serviceName] isEqual: [anObject serviceName]]) {
      return YES;
    } else {
      return NO;
    }
  } else {
    return NO;
  }
}

- (NSUInteger)hash {
  return [[url absoluteString] hash];
}

- (void)dealloc {
  [syncController release];
  [service release];
  [url release];
  [super dealloc];
}

@end

@implementation CBRemoteCloudboard(Delegation)

//NSNetServiceDelegate
- (void)netServiceDidResolveAddress:(NSNetService *)netService {
  NSInteger port = [netService port];
  NSString *host = [netService hostName];
  NSMutableString *URLString = [NSMutableString string];
  [URLString appendString:@"http://"];
  [URLString appendString:host];
  [URLString appendString:@":"];
  [URLString appendString:[[NSNumber numberWithUnsignedInteger:port] stringValue]];
  url = [[NSURL alloc] initWithString:URLString];
  if(registerClient) {
    [self sendRegistration];
  }
  if(confirmClient) {
    [self sendRegistrationConfirmation];
  }
}

- (void)netService:(NSNetService *)netServiceDidNotResolve:(NSDictionary *)errorDict {
  NSLog(@"error: not resolved address: %@", errorDict);
}

@end

@implementation CBRemoteCloudboard(Private)

- (void)resolveService {
  [service setDelegate: self];
  [service resolveWithTimeout:5];
}

- (void)sendRegistration {
  NSLog(@"try to register as client of: %@", url);
  NSURL *requestURL = [url URLByAppendingPathComponent:@"register"];
  NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:requestURL];
  [URLRequest setHTTPMethod:@"POST"];
  [URLRequest setHTTPBody:[[syncController serviceName] dataUsingEncoding: NSUTF8StringEncoding]];
  NSURLResponse *URLResponse = nil;
  NSError *receivedError = nil;
  NSData *receivedData = [NSURLConnection sendSynchronousRequest:URLRequest
                                               returningResponse:&URLResponse
                                                           error:&receivedError];
  NSLog(@"registration response: %@", [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease]);
}

- (void)sendRegistrationConfirmation {
  NSLog(@"confirm registration of: %@", url);
  NSURL *requestURL = [url URLByAppendingPathComponent:@"confirm"];
  NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:requestURL];
  [URLRequest setHTTPMethod:@"POST"];
  [URLRequest setHTTPBody:[[syncController serviceName] dataUsingEncoding: NSUTF8StringEncoding]];
  NSURLResponse *URLResponse = nil;
  NSError *receivedError = nil;
  NSData *receivedData = [NSURLConnection sendSynchronousRequest:URLRequest
                                               returningResponse:&URLResponse
                                                           error:&receivedError];
  NSLog(@"confirmation response: %@", [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease]);
}
@end
