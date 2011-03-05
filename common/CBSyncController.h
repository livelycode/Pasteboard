//
//  SyncController.h
//  cloudboard
//
//  Created by Mirko on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cloudboard.h"
@class CBRemoteCloudboard, CBApplicationController;

@interface CBSyncController : NSObject {
@private
  HTTPServer* httpServer;
  NSNetServiceBrowser* serviceBrowser;
  NSString* myServiceName;
  CBClipboardController* clipboardController;
  CBApplicationController* appController;
  
  NSMutableDictionary* clientsVisible;
  NSMutableDictionary* clientsToSearch;
  NSMutableDictionary* clientsConnected;
  NSMutableDictionary* clientsAwaitingConfirm;
}
- (id) initWithClipboardController: (CBClipboardController*)controller
                     appController:(CBApplicationController*)appController;
- (void)syncItem: (CBItem*)item atIndex: (NSInteger)index;
- (NSString*) serviceName;
@end

@interface CBSyncController(Private)
- (void)launchHTTPServer;
- (void)searchRemotes;
- (void)foundClient:(CBRemoteCloudboard*)client;
- (BOOL)clientToRegister:(CBRemoteCloudboard*)client;
- (void)addClient: (CBRemoteCloudboard*)client;
@end

@interface CBSyncController(Delegation)<NSNetServiceBrowserDelegate, NSNetServiceDelegate>
//NSNetServiceBrowserDelegate
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)netServiceBrowser;
- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didNotSearch:(NSDictionary *)errorInfo;
- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindDomain:(NSString *)domainName moreComing:(BOOL)moreDomainsComing;
- (void)netServiceBrowser:(NSNetServiceBrowser *) browser didFindService: (NSNetService*) service moreComing: (BOOL)more;
- (void)netServiceBrowser:(NSNetServiceBrowser *) browser didRemoveService: (NSNetService*) service moreComing: (BOOL)more;
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser;

//CBClipboardControllerDelegate
- (void)didSetItem: (CBItem *)item atIndex: (NSInteger)index;

//CBHTTPConnectionDelegate
- (void)registrationRequestFrom:(NSString*)serviceName;
- (void)registrationConfirmationFrom:(NSString*)serviceName;
- (void)receivedRemoteItem: (CBItem*)item atIndex: (NSInteger) index;
@end