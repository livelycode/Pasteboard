//
//  SyncController.h
//  cloudboard
//
//  Created by Mirko on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CBSyncController : NSObject {
@private
  NSNetServiceBrowser *serviceBrowser;
  NSTimer *timer;
  NSNetService *service;
  NSString *host;
  NSInteger port;
}

- (void) searchRemotes: (NSTimer*) timer;
- (void) setService: (NSNetService*) service;
- (void) resolveService;
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
@end