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

- (void)syncAddedItem:(CBItem*)item {
  NSData* archivedItem = [NSKeyedArchiver archivedDataWithRootObject:[item string]];
  [self postToPath:@"add" withData:archivedItem];
}

- (void)syncItems:(NSArray*)items {
  NSMutableString* string = [NSMutableString string];
  for(id item in items) {
    if([item isEqual:[NSNull null]]) {
      
    } else {
      [string appendString:@"com.cloudboard.separator"];
      [string appendString:[item string]];
    }
  }
  NSData* archivedItem = [NSKeyedArchiver archivedDataWithRootObject:string];
  [self postToPath:@"initialsync" withData:archivedItem];
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

//NSURLConnectionDelegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  
}

@end

@implementation CBRemoteCloudboard(Private)

- (void)resolveService {
  [service setDelegate: self];
  [service resolveWithTimeout:5];
}

- (void)postToPath:(NSString*)path withData:(NSData*)data {
  NSURL *requestURL = [url URLByAppendingPathComponent:path];
  NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:requestURL];
  [URLRequest setHTTPMethod:@"POST"];
  [URLRequest setHTTPBody:data];
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
  dispatch_async(queue,^{
    NSURLResponse *URLResponse = nil;
    NSError *receivedError = nil;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:URLRequest returningResponse:&URLResponse
                                                             error:&receivedError];
    NSLog(@"post to path: %@ response: %@", path, [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease]);
  });
}

- (void)sendRegistration {
  NSLog(@"try to register as client of: %@", url);
  [self postToPath:@"register" withData:[[syncController serviceName] dataUsingEncoding: NSUTF8StringEncoding]];
}

- (void)sendRegistrationConfirmation {
  NSLog(@"confirm registration of: %@", url);
  [self postToPath:@"confirm" withData:[[syncController serviceName] dataUsingEncoding: NSUTF8StringEncoding]];
}
@end
