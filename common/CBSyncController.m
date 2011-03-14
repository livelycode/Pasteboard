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
    delegates = [[NSMutableArray alloc] init];
    serviceBrowser = [[NSNetServiceBrowser alloc] init];
    [serviceBrowser setDelegate:self];
        
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* clientsToSearchSettings = [userDefaults arrayForKey:@"clients"];
    if(clientsToSearchSettings) {
      clientsToSearch = [[NSMutableArray alloc] initWithArray:clientsToSearchSettings];
    } else {
      clientsToSearch = [[NSMutableArray alloc] init];
    }
    
    clientsVisible = [[NSMutableDictionary alloc] init];
    clientsConnected = [[NSMutableArray alloc] init];
    clientsIAwaitConfirm = [[NSMutableArray alloc] init];
    
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

- (void)setClientsToSearch:(NSArray *)clientNames {
  for(NSString* clientName in clientNames) {
    [self addClientToSearch:clientName];
  }
}

- (void)addClientToSearch:(NSString *)clientName {
  if([clientsToSearch containsObject:clientName] == NO) {
    [clientsToSearch addObject:clientName];
    CBRemoteCloudboard* visibleClient = [clientsVisible objectForKey:clientName];
    if([clientsUserNeedsToConfirm containsObject:clientName]) {
      [clientsQueuedForConfirm addObject:clientName];
      [clientsUserNeedsToConfirm removeObject:clientName];
    }
    if(visibleClient) {
      [self foundClient:visibleClient];
    }
    [self persistClientsToSearch];
  }
}

- (void)removeClientToSearch:(NSString*)clientName {
  [clientsToSearch removeObject:clientName];
  [clientsConnected removeObject:clientName];
  [self informDelegatesWith:@selector(clientDisconnected:) object:clientName]; 
  [self persistClientsToSearch];
}

- (NSArray*)clientsVisible {
  return [clientsVisible allKeys];
}

- (NSArray*)clientsConnected {
  return [NSArray arrayWithArray:clientsConnected];
}

- (NSArray*)clientsToSearch {
  return [NSArray arrayWithArray: clientsToSearch];
}

- (NSArray*)clientsRequiringUserConfirm {
  return clientsUserNeedsToConfirm;
}

- (void)dealloc {
  [httpServer release];
  [serviceBrowser release];
  [myServiceName release];
  [clipboardController release];
  [delegates release];
  
  [clientsVisible release];
  [clientsConnected release];
  [clientsIAwaitConfirm release];
  
  [clientsToSearch release];
  [clientsUserNeedsToConfirm release];
  [clientsQueuedForConfirm release];
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
  [clientsIAwaitConfirm addObject:[client serviceName]];
}

- (void)initialSyncToClient:(CBRemoteCloudboard *)client {
  NSLog(@"starting initial sync to %@", [client serviceName]);
  [client syncItems:[clipboardController allItems] withDate:[clipboardController lastChanged]];
}

- (void)informDelegatesWith:(SEL)selector object:(id)object {
  for(id<CBSyncControllerProtocol> delegate in delegates) {
    if([delegate respondsToSelector:selector]) {
      [delegate performSelector:selector withObject:object];
    }
  }
}

- (void)persistClientsToSearch {
  NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:clientsToSearch forKey:@"clients"];
  [userDefaults synchronize];
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
    [clientsVisible setValue:nil forKey:[netService name]];
    [clientsConnected removeObject:[netService name]];
    [self informDelegatesWith:@selector(clientBecameInvisible:) object:[netService name]]; 
  }
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser {
  NSLog(@"stopped searching");
}

//CBClipboardControllerDelegate
- (void)didAddItem:(CBItem*)item {
  for(NSString* clientName in clientsConnected) {
    CBRemoteCloudboard* client = [clientsVisible valueForKey:clientName];
    [client syncAddedItem: item];
  }
}

- (void)didResetItems {
  for(NSString* clientName in clientsConnected) {
    CBRemoteCloudboard* client = [clientsVisible valueForKey:clientName];
    [client resetItems];
  }
}

//CBHTTPConnectionDelegate
- (void)registrationRequestFrom:(NSString *)clientName {
  //if([clientsToSearch containsObject:clientName]) {
  //always true for testing:
  if(YES) {
    CBRemoteCloudboard* visibleClient = [clientsVisible objectForKey:clientName];
    if(visibleClient) {
      [self confirmClient:visibleClient];
    } else {
      [clientsQueuedForConfirm addObject:clientName];    
    }
  } else {
    [clientsUserNeedsToConfirm addObject:clientName];
    [self informDelegatesWith:@selector(clientRequiresUserConfirmation:) object:clientName];
  }
}

- (void)registrationConfirmationFrom:(NSString *)serviceName {
  CBRemoteCloudboard* client = [clientsVisible objectForKey:serviceName];
  [clientsConnected addObject:serviceName];
  [clientsIAwaitConfirm removeObject:serviceName];
  [self informDelegatesWith:@selector(clientConnected:)object:serviceName];
  [self initialSyncToClient: client];
}

- (void)receivedAddedRemoteItem: (CBItem*)item {
  NSLog(@"received item: %@", [item string]);
  [clipboardController addItem:item syncing:NO];
}

- (void)receivedRemoteItems: (NSArray*)items changedDate:(NSDate *)date {
  NSDate* localLastChanged = [clipboardController lastChanged];
  NSLog(@"received items: %@ changed: %@ local: %@", items, date, localLastChanged);
  if([[clipboardController lastChanged] compare:date] == NSOrderedAscending) {
    [clipboardController clearClipboardSyncing:NO];
    for(CBItem* item in [[items reverseObjectEnumerator] allObjects]) {
      [clipboardController addItem:item syncing:NO];
    }
  } else {
    NSLog(@"I have better stuff!");
  }
}

- (void)receivedReset {
  [clipboardController clearClipboardSyncing:NO];
}
@end