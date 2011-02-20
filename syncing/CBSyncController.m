//
//  SyncController.m
//  cloudboard
//
//  Created by Mirko on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBSyncController.h"


@implementation CBSyncController

- (id)initWithClipboardController: (CBClipboardController*) controller
{
  self = [super init];
  if (self) {
      // Initialization code here.
  }
  [controller addChangeListener: self];
  clipboardController = controller;
  serviceBrowser = [[NSNetServiceBrowser alloc] init];
  [serviceBrowser setDelegate:self];
  clients = [NSMutableArray array];
  timer = [NSTimer scheduledTimerWithTimeInterval:2 target: self selector:@selector(searchRemotes:) userInfo:nil repeats: NO];
  
  //start Server in new thread
  NSThread *serverThread = [[NSThread alloc] initWithTarget:self selector: @selector(launchHTTPServer) object:nil];
  [serverThread start];
  return self;
}

- (void)launchHTTPServer {
  HTTPServer *server = [[HTTPServer alloc] init];
  [server setType:@"_http._tcp."];
  [server setName:@"Cloudboard Server"];
  [server setPort: 8090];
  HTTPConnectionDelegate *connectionDelegate = [[HTTPConnectionDelegate alloc] initWithSyncController: self];
  [server setDelegate: connectionDelegate];
  
  NSError *startError = nil;
  if (![server start:&startError] ) {
    NSLog(@"Error starting server: %@", startError);
  } else {
    NSLog(@"Starting server on port %d", [server port]);
  }
  [[NSRunLoop currentRunLoop] run];
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
  if([clients containsObject: client] == NO) {
    NSLog(@"added client: %@", client);
    [clients addObject: client];    
  }
}

- (void) registerAsClientOf: (NSURL*) server {
  NSString* myHost = [[NSHost currentHost] name];
  NSURL *requestURL = [server URLByAppendingPathComponent:@"register"];
  NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:requestURL];
  [URLRequest setHTTPMethod:@"POST"];
  [URLRequest setHTTPBody:[myHost dataUsingEncoding: NSUTF8StringEncoding]];
  NSURLResponse *URLResponse = nil;
  NSError *receivedError = nil;
  NSData *receivedData = [NSURLConnection sendSynchronousRequest:URLRequest
                                               returningResponse:&URLResponse
                                                           error:&receivedError];
  NSLog(@"registration response: %@", [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease]);
  
  
}

- (void) resolveService {
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
  [self registerAsClientOf: client];
  [self addClient: client];
}

- (void)netService:(NSNetService *)netServiceDidNotResolve:(NSDictionary *)errorDict {
  NSLog(@"error: not resolved address: %@", errorDict);
}

//CBClipboardControllerDelegate
- (void)insertedItem:(CBItem*)item atIndex: (NSInteger) index {
  NSLog(@"received notification");
}
@end