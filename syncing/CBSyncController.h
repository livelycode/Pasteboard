//
//  SyncController.h
//  cloudboard
//
//  Created by Mirko on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cloudboard.h"

@interface CBSyncController : NSObject {
@private
  NSNetServiceBrowser *serviceBrowser;
  NSTimer *timer;
  NSNetService *service;
  NSMutableArray *clients;
  CBClipboardController *clipboardController;
}
- (id) initWithClipboardController: (CBClipboardController*)controller;
- (void)launchHTTPServer;
- (void) searchRemotes: (NSTimer*) timer;
- (void) addClient: (NSURL*) client;
- (void) registerAsClientOf: (NSURL*) server;
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
@end