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
  
  NSUInteger myPort = 8090;
  NSMutableString *URLString = [NSMutableString string];
  [URLString appendString:@"http://"];
  [URLString appendString:[[NSHost currentHost] name]];
  [URLString appendString:@":"];
  [URLString appendString:[[NSNumber numberWithUnsignedInteger: myPort] stringValue]];
  myAddress = [NSURL URLWithString:URLString];
  
  NSMutableString* tempServiceString = [NSMutableString string];
  [tempServiceString appendString: @"Cloudboard Server "];
  [tempServiceString appendString: [myAddress host]];
  myServiceName = [NSString stringWithString:tempServiceString];
  
  //start Server in new thread
  [self searchRemotes];
  NSThread *serverThread = [[NSThread alloc] initWithTarget:self selector: @selector(launchHTTPServer) object:nil];
  [serverThread start];
  return self;
}

-(NSURL*) URL {
  return myAddress;
}

- (void)launchHTTPServer {
  HTTPServer *server = [[HTTPServer alloc] init];
  [server setType:@"_http._tcp."];
  [server setName: myServiceName];
  [server setPort: [[myAddress port] intValue]];
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

- (void) searchRemotes {
  NSLog(@"invoke search");
  [serviceBrowser searchForServicesOfType:@"_http._tcp." inDomain:@"local."];    
}


- (void) setServerService: (NSNetService*) newService {
  serverService = newService;
  [self resolveService];
}

- (void) addClient: (CBRemoteCloudboard*) newClient {
  if([clients containsObject: newClient] == NO) {
    NSLog(@"added client: %@", [newClient URL]);
    [clients addObject: newClient];    
  }
}

- (void) registerAsClientOf: (CBRemoteCloudboard*)server {
  NSURL *requestURL = [[server URL] URLByAppendingPathComponent:@"register"];
  NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:requestURL];
  [URLRequest setHTTPMethod:@"POST"];
  [URLRequest setHTTPBody:[[myAddress absoluteString] dataUsingEncoding: NSUTF8StringEncoding]];
  NSURLResponse *URLResponse = nil;
  NSError *receivedError = nil;
  NSData *receivedData = [NSURLConnection sendSynchronousRequest:URLRequest
                                               returningResponse:&URLResponse
                                                           error:&receivedError];
  NSLog(@"registration response: %@", [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease]);
  [self addClient:server];
}

- (void) resolveService {
  [serverService setDelegate: self];
  [serverService resolveWithTimeout:5];
}

- (void)syncItem: (CBItem*)item atIndex: (NSInteger)index {
  for(CBRemoteCloudboard* client in clients) {
    [client syncItem: item atIndex: index];
  }
}

- (void)dealloc
{
    [super dealloc];
}

@end

@implementation CBSyncController(Delegation)

//NSNetServiceBrowserDelegate
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
  if([[newService name] hasPrefix: @"Cloudboard Server"] & ([[newService name] isEqual: myServiceName] == NO)) {
      [self setServerService: newService];      
  }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *) browser didRemoveService: (NSNetService*) netService moreComing: (BOOL)more {
  NSLog(@"removed service: %@", netService);
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser {
  NSLog(@"stopped searching");
}

//NSNetServiceDelegate
- (void)netServiceDidResolveAddress:(NSNetService *)netService {
  NSInteger port = [netService port];
  NSString *host = [netService hostName];
  CBRemoteCloudboard* newServer = [[CBRemoteCloudboard alloc] initWithHost:host port:port];
  [newServer addClient:self];
}

- (void)netService:(NSNetService *)netServiceDidNotResolve:(NSDictionary *)errorDict {
  NSLog(@"error: not resolved address: %@", errorDict);
}

//CBClipboardControllerDelegate
- (void)insertedItem:(CBItem*)item atIndex: (NSInteger) index {
  [self syncItem: item atIndex: index];
  NSLog(@"received notification");
}

//HTTPConnectionDelegateDelegate
- (void)receivedItem: (CBItem*)item atIndex: (NSInteger) index {
  NSLog(@"got item: %@", [[item string] string]);
}
@end