//
//  SyncController.m
//  cloudboard
//
//  Created by Mirko on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CBSyncController.h"

@implementation CBSyncController
- (id)initWithClipboardController: (CBClipboardController*) aSyncController
                    appController:(CBApplicationController *)anAppController{
  self = [super init];
  if (self) {
    appController = [anAppController retain];
    clipboardController = [aSyncController retain];
    [aSyncController addChangeListener: self];
    
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

-(NSString*) serviceName {
  return myServiceName;
}

- (void)syncItem: (CBItem*)item atIndex: (NSInteger)index {
  for(CBRemoteCloudboard* client in clientsConnected) {
    [client syncItem: item atIndex: index];
  }
}

- (void)setClientsToSearch:(NSArray *)clientNames {
  clientsToSearch = [[NSMutableArray alloc] initWithArray: clientNames];
}

- (void)addClientToSearch:(NSString *)clientName {
  if([clientsToSearch containsObject:clientName] == NO) {
    [clientsToSearch addObject:clientName];
  }
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
  
  if([clientsQueuedForConfirm containsObject:[client serviceName]]) {
    [client confirmClient];
    [clientsQueuedForConfirm removeObject:[client serviceName]];
  }
  if([self clientToRegister:client]) {
    [client registerAsClient];
    [clientsIAwaitConfirm setValue:client forKey:[client serviceName]];
  }
}

- (BOOL)clientToRegister:(CBRemoteCloudboard*)client {
  //only for testing:
  return true;
  if([clientsToSearch containsObject:[client serviceName]]) {
    CBRemoteCloudboard* alreadyRegisteredClient = [clientsConnected objectForKey:[client serviceName]];
    CBRemoteCloudboard* alreadyAwaitingClient = [clientsIAwaitConfirm objectForKey:[client serviceName]];
    if((alreadyRegisteredClient == nil) & (alreadyAwaitingClient == nil)) {
      return YES;
    } else {
      return NO;
    }
  } else {
    return NO;
  }
}

- (void)clientNeedsUserConfirm:(NSString*)clientName {
  [appController clientAsksForRegistration:clientName];
}

- (void)queueClientForConfirm:(NSString*)clientName {
  CBRemoteCloudboard* visibleClient = [clientsVisible objectForKey:clientName];
  if(visibleClient) {
    [visibleClient confirmClient];
  } else {
    [clientsQueuedForConfirm addObject:clientName];    
  }
}

- (void)initialSyncTo:(CBRemoteCloudboard *)client {
  NSLog(@"starting initial sync to %@", [client serviceName]);
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
  if([[newService name] hasPrefix: @"Cloudboard"] & ([[newService name] isEqual: myServiceName] == NO)) {
    CBRemoteCloudboard* client = [[CBRemoteCloudboard alloc] initWithService:newService syncController:self];
    [self foundClient:client];
  }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *) browser didRemoveService: (NSNetService*) netService moreComing: (BOOL)more {
  NSLog(@"removed service: %@", netService);
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser {
  NSLog(@"stopped searching");
}

//CBClipboardControllerDelegate
- (void)didSetItem:(CBItem*)item atIndex: (NSInteger) index {
  NSLog(@"sync item");
  [self syncItem: item atIndex: index];
  NSLog(@"received notification");
}

//CBHTTPConnectionDelegate
- (void)registrationRequestFrom:(NSString *)serviceName {
  if([clientsToSearch containsObject:serviceName]) {
    [self queueClientForConfirm:serviceName];
  } else {
    [self clientNeedsUserConfirm:serviceName];
  }
}

- (void)registrationConfirmationFrom:(NSString *)serviceName {
  CBRemoteCloudboard* client = [clientsIAwaitConfirm objectForKey:serviceName];
  [clientsConnected setValue:client forKey:serviceName];
  [clientsIAwaitConfirm setValue:nil forKey:serviceName];
  [self initialSyncTo: client];
}

- (void)receivedRemoteItem: (CBItem*)item atIndex: (NSInteger) index {
  NSLog(@"received item: %@", [[item string] string]);
  [clipboardController setItemQuiet:item atIndex:index];
}
@end