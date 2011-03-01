//
//  SyncController.h
//  cloudboard
//
//  Created by Mirko on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cloudboard.h"
@class CBRemoteCloudboard;

@interface CBSyncController : NSObject {
@private
  NSNetServiceBrowser *serviceBrowser;
  NSNetService *serverService;
  NSMutableArray *clients;
  NSURL* myAddress;
  NSString* myServiceName;
  CBClipboardController *clipboardController;
}
- (id) initWithClipboardController: (CBClipboardController*)controller;
- (void)launchHTTPServer;
- (void) searchRemotes;
- (void) addClient: (CBRemoteCloudboard*)client;
- (void) registerAsClientOf: (CBRemoteCloudboard*)server;
- (void) syncItem: (CBItem*)item atIndex: (NSInteger)index;
- (NSURL*) URL;
@end

@interface CBSyncController(Delegation)<NSNetServiceBrowserDelegate, NSNetServiceDelegate>
//NSNetServiceBrowserDelegate
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)netServiceBrowser;
- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didNotSearch:(NSDictionary *)errorInfo;
- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindDomain:(NSString *)domainName moreComing:(BOOL)moreDomainsComing;
- (void)netServiceBrowser:(NSNetServiceBrowser *) browser didFindService: (NSNetService*) service moreComing: (BOOL)more;
- (void)netServiceBrowser:(NSNetServiceBrowser *) browser didRemoveService: (NSNetService*) service moreComing: (BOOL)more;
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser;

//NSNetServiceDelegate
- (void)netServiceDidResolveAddress:(NSNetService *)netService;
- (void)netService:(NSNetService *)netServiceDidNotResolve:(NSDictionary *)errorDict;

//CBClipboardControllerDelegate
- (void)insertedItem: (CBItem *)item atIndex: (NSInteger)index;

//HTTPConnectionDelegateDelegate
- (void)receivedItem: (CBItem*)item atIndex: (NSInteger) index;
@end