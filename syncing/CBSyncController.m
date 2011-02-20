//
//  SyncController.m
//  cloudboard
//
//  Created by Mirko on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBSyncController.h"


@implementation CBSyncController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    serviceBrowser = [[NSNetServiceBrowser alloc] init];
    [serviceBrowser setDelegate:self];
    clients = [NSMutableArray array];
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target: self selector:@selector(searchRemotes:) userInfo:nil repeats: NO];
    return self;
}

- (void) searchRemotes: (NSTimer*) timer {
  NSLog(@"invoke search");
  [serviceBrowser searchForServicesOfType:@"_http._tcp." inDomain:@"local."];    
}


- (void) setService: (NSNetService*) newService {
  service = newService;
  [self resolveService];
}

- (void) addClient: (NSURL*) client {
  [clients addObject: client];
}

- (void) resolveService {
  [service setDelegate:self];
  [service resolveWithTimeout:5];
}

- (NSURL *)urlWithHost: (NSString*)host port: (NSInteger)port
{
  NSMutableString *URLString = [NSMutableString string];
  [URLString appendString:@"http://"];
  [URLString appendString:host];
  [URLString appendString:@":"];
  [URLString appendString:[[NSNumber numberWithUnsignedInteger:port] stringValue]];
  return [NSURL URLWithString:URLString];
}

- (void)dealloc
{
    [super dealloc];
}

@end

@implementation CBSyncController(Delegation)

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)netServiceBrowser {
  NSLog(@"searching services");
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didNotSearch:(NSDictionary *)errorInfo {
  NSLog(@"error: did not search services %@", errorInfo);
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindDomain:(NSString *)domainName moreComing:(BOOL)more {
  NSLog(@"found domain: %@", domainName);
}

- (void)netServiceBrowser:(NSNetServiceBrowser *) browser didFindService: (NSNetService*) newService moreComing: (BOOL)more; {
  NSLog(@"found service: %@ on port: %i, more coming: %i", newService, [newService port], more);
  if([[newService name] isEqual:@"Cloudboard Server"]) {
    [self setService: newService];
  } else {
    if((more == NO) && (service == nil)) {
      [browser stop];
      [NSTimer scheduledTimerWithTimeInterval:2 target: self selector:@selector(searchRemotes:) userInfo:nil repeats: NO];
    }
  }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *) browser didRemoveService: (NSNetService*) netService moreComing: (BOOL)more {
  NSLog(@"removed service: %@", netService);
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser {
  NSLog(@"stopped searching");
}

- (void)netServiceDidResolveAddress:(NSNetService *)netService {
  NSInteger port = [netService port];
  NSString *host = [netService hostName];
  NSURL *client = [self urlWithHost:host port: port];
  [self addClient: client];
  NSLog(@"server URL: %@", [self urlWithHost:host port: port]);
}

- (void)netService:(NSNetService *)netServiceDidNotResolve:(NSDictionary *)errorDict {
  NSLog(@"error: not resolved address: %@", errorDict);
}

//CBClipboardControllerDelegate
- (void)insertedItem:(CBItem*)item atIndex: (NSInteger) index {
  NSLog(@"received notification");
}
@end