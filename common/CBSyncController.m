//
//  SyncController.m
//  cloudboard
//
//  Created by Mirko on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBSyncController.h"

@implementation CBSyncController
- (id)initWithClipboardController: (CBClipboardController*) aSyncController {
  self = [super init];
  if (self) {
    clipboardController = [aSyncController retain];
    [clipboardController addChangeListener: self];
    delegates = [[NSMutableArray alloc] init];
    serviceBrowser = [[NSNetServiceBrowser alloc] init];
    [serviceBrowser setDelegate:self];
    
    clientsVisible = [[NSMutableDictionary alloc] init];
    clientsConnected = [[NSMutableDictionary alloc] init];
    clientsIAwaitConfirm = [[NSMutableDictionary alloc] init];
    
    clientsToSearch = [[NSMutableArray alloc] init];
    clientsUserNeedsToConfirm = [[NSMutableArray alloc] init];
    clientsQueuedForConfirm = [[NSMutableArray alloc] init];
    
    NSMutableString* tempServiceString = [NSMutableString string];
    [tempServiceString appendString: @"Cloudboard "];
    [tempServiceString appendString: [[NSHost currentHost] name]];
    myServiceName = [[NSString alloc] initWithString:tempServiceString];
    
    [self launchHTTPServer];
    [self searchRemotes];
  }
  return self;
}

- (void)addDelegate:(id<CBSyncControllerProtocol>)delegate {
  if([delegates containsObject:delegate] == NO) {
    [delegates addObject:delegate];
  }
}

-(NSString*) serviceName {
  return myServiceName;
}

- (void)syncAddedItem: (CBItem*)item {
  for(CBRemoteCloudboard* client in [clientsConnected allValues]) {
    [client syncAddedItem: item];
  }
}

- (void)syncItem: (CBItem*)item atIndex: (NSInteger)index {
  for(CBRemoteCloudboard* client in [clientsConnected allValues]) {
    [client syncItem: item atIndex: index];
  }
}

- (void)setClientsToSearch:(NSArray *)clientNames {
  for(NSString* clientName in clientNames) {
    [self addClientToSearch:clientName];
  }
}

- (void)addClientToSearch:(NSString *)clientName {
  if([clientsToSearch containsObject:clientName] == NO) {
    [clientsToSearch addObject:clientName];
    CBRemoteCloudboard* visibleClient = [clientsVisible objectForKey:clientName];
    if(visibleClient) {
      [self foundClient:visibleClient];
    }
  }
}

- (void)removeClientToSearch:(NSString*)clientName {
  [clientsToSearch removeObject:clientName];
  [clientsConnected setValue:nil forKey:clientName];
  [self informDelegatesWith:@selector(clientDisconnected:) object:clientName]; 
}

- (NSArray*)visibleClients {
  return [clientsVisible allKeys];
}

- (NSArray*)connectedClients {
  return [clientsConnected allKeys];
}

- (NSArray*)clientsRequiringUserConfirm {
  return clientsUserNeedsToConfirm;
}

- (void)dealloc {
  [serviceBrowser release];
  [clientsConnected release];
  [myServiceName release];
  [clipboardController release];
  [super dealloc];
}
@end

@implementation CBSyncController(Private)

- (void)launchHTTPServer {
  httpServer = [[HTTPServer alloc] init];
  
  // Tell the server to broadcast its presence via Bonjour.
  [httpServer setType:@"_http._tcp."];
  [httpServer setName:myServiceName];
  //[httpServer setPort:8090];
  [httpServer setConnectionClass:[CBHTTPConnection class]];
  
  NSError *error = nil;
  if(![httpServer start:&error]) {
    NSLog(@"Error starting HTTP Server: %@", error);
  } else {
    NSLog(@"Server started");
  }
}

- (void) searchRemotes {
  NSLog(@"invoke search");
  [serviceBrowser searchForServicesOfType:@"_http._tcp." inDomain:@"local."];    
}

- (void)foundClient:(CBRemoteCloudboard *)client {
  NSLog(@"found client: %@", [client serviceName]);
  [clientsVisible setValue:client forKey:[client serviceName]];
  [self informDelegatesWith:@selector(clientBecameVisible:) object:[client serviceName]];
  if([clientsQueuedForConfirm containsObject:[client serviceName]]) {
    [self confirmClient:client];
    [clientsQueuedForConfirm removeObject:[client serviceName]];
  }
  //for testing always register:
  if([clientsToSearch containsObject:[client serviceName]]) {
    [self registerAsClientOf:client];
  }
}

- (void)confirmClient:(CBRemoteCloudboard*)client {
  [client confirmClient];
  [self informDelegatesWith:@selector(clientConfirmed:) object:[client serviceName]];
}

- (void)registerAsClientOf:(CBRemoteCloudboard*)client {
  [client registerAsClient];
  [clientsIAwaitConfirm setValue:client forKey:[client serviceName]];
}

- (void)initialSyncToClient:(CBRemoteCloudboard *)client {
  NSLog(@"starting initial sync to %@", [client serviceName]);
  NSInteger index = 0;
  for(CBItem* item in [clipboardController allItems]) {
    [self syncItem:item atIndex:index];
    index++;
  }
}

- (void)informDelegatesWith:(SEL)selector object:(id)object {
  for(id<CBSyncControllerProtocol> delegate in delegates) {
    if([delegate respondsToSelector:selector]) {
      [delegate performSelector:selector withObject:object];
    }
  }
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
  if([[newService name] hasPrefix: @"Cloudboard"] & ([[newService name] isEqual: myServiceName] == NO)) {
    CBRemoteCloudboard* client = [[CBRemoteCloudboard alloc] initWithService:newService syncController:self];
    [self foundClient:client];
  }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *) browser didRemoveService: (NSNetService*) netService moreComing: (BOOL)more {
  NSLog(@"removed service: %@", netService);
  if([[netService name] hasPrefix: @"Cloudboard"]) {
    [self informDelegatesWith:@selector(clientBecameInvisible:) object:[netService name]]; 
  }
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser {
  NSLog(@"stopped searching");
}

//CBClipboardControllerDelegate
- (void)didAddItem:(CBItem*)item {
  NSLog(@"sync item");
  [self syncAddedItem:item];
}

//CBHTTPConnectionDelegate
- (void)registrationRequestFrom:(NSString *)clientName {
  if([clientsToSearch containsObject:clientName]) {
  //always true for testing:
  //if(YES) {
    CBRemoteCloudboard* visibleClient = [clientsVisible objectForKey:clientName];
    if(visibleClient) {
      [self confirmClient:visibleClient];
    } else {
      [clientsQueuedForConfirm addObject:clientName];    
    }
  } else {
    [self informDelegatesWith:@selector(clientRequiresUserConfirmation:) object:clientName];
  }
}

- (void)registrationConfirmationFrom:(NSString *)serviceName {
  CBRemoteCloudboard* client = [clientsIAwaitConfirm objectForKey:serviceName];
  [clientsConnected setValue:client forKey:serviceName];
  [clientsIAwaitConfirm setValue:nil forKey:serviceName];
  [self informDelegatesWith:@selector(clientConnected:)object:serviceName];
  [self initialSyncToClient: client];
}

- (void)receivedAddedRemoteItem: (CBItem*)item {
  NSLog(@"received item: %@", [[item string] string]);
  [clipboardController addItem:item syncing:NO];
}

- (void)receivedRemoteItem: (CBItem*)item atIndex: (NSInteger) index {
  NSLog(@"received item: %@", [[item string] string]);
  [clipboardController setItem:item atIndex:index syncing:NO];
}
@end