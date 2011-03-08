//
//  SyncController.h
//  cloudboard
//
//  Created by Mirko on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cloudboard.h"
#import "CBSyncControllerProtocol.h"
@class CBRemoteCloudboard, CBApplicationController;

@interface CBSyncController : NSObject {
@private
  HTTPServer* httpServer;
  NSNetServiceBrowser* serviceBrowser;
  NSString* myServiceName;
  CBClipboardController* clipboardController;
  NSMutableArray* delegates;
  
  //CBRemoteCloudboardArrays:
  NSMutableDictionary* clientsVisible;
  NSMutableDictionary* clientsConnected;
  NSMutableDictionary* clientsIAwaitConfirm;
  //Service Name Arrays:
  NSMutableArray* clientsToSearch;
  NSMutableArray* clientsUserNeedsToConfirm;
  NSMutableArray* clientsQueuedForConfirm;
}
- (id) initWithClipboardController: (CBClipboardController*)controller;
- (void)addDelegate:(id<CBSyncControllerProtocol>)delegate;
- (void)syncAddedItem:(CBItem*)item;
- (void)syncItem: (CBItem*)item atIndex: (NSInteger)index;
- (void)setClientsToSearch:(NSArray*)clientNames;
- (void)addClientToSearch:(NSString*)clientName;
- (void)removeClientToSearch:(NSString*)clientName;
- (NSArray*)visibleClients;
- (NSArray*)connectedClients;
- (NSArray*)clientsRequiringUserConfirm;
- (NSString*) serviceName;
@end

@interface CBSyncController(Private)
- (void)launchHTTPServer;
- (void)searchRemotes;
- (void)foundClient:(CBRemoteCloudboard*)client;
- (void)registerAsClientOf:(CBRemoteCloudboard*)client;
- (void)confirmClient:(CBRemoteCloudboard*)client;
- (void)initialSyncToClient:(CBRemoteCloudboard*)client;
- (void)informDelegatesWith:(SEL)selector object:(id)object;
@end

@interface CBSyncController(Delegation)<NSNetServiceBrowserDelegate, NSNetServiceDelegate>
//NSNetServiceBrowserDelegate
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)netServiceBrowser;
- (void)netServiceBrowser:(NSNetServiceBrowser*)netServiceBrowser didNotSearch:(NSDictionary *)errorInfo;
- (void)netServiceBrowser:(NSNetServiceBrowser*)netServiceBrowser didFindDomain:(NSString *)domainName
               moreComing:(BOOL)moreDomainsComing;
- (void)netServiceBrowser:(NSNetServiceBrowser*)browser didFindService:(NSNetService*)service 
               moreComing:(BOOL)more;
- (void)netServiceBrowser:(NSNetServiceBrowser *) browser didRemoveService:(NSNetService*)service 
               moreComing:(BOOL)more;
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser;

//CBClipboardControllerDelegate
- (void)didAddItem: (CBItem *)item;
//CBHTTPConnectionDelegate
- (void)registrationRequestFrom:(NSString*)serviceName;
- (void)registrationConfirmationFrom:(NSString*)serviceName;
- (void)receivedAddedRemoteItem: (CBItem*)item;
- (void)receivedRemoteItem: (CBItem*)item atIndex: (NSInteger) index;
@end