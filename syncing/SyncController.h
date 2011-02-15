//
//  SyncController.h
//  cloudboard
//
//  Created by Mirko on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SyncController : NSObject <NSNetServiceBrowserDelegate> {
@private
  NSNetServiceBrowser *serviceBrowser;
  NSTimer *timer;
  NSNetService *service;
}

- (void) searchRemotes: (NSTimer*) timer;
@end

@interface SyncController(Delegation)
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)netServiceBrowser;
- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didNotSearch:(NSDictionary *)errorInfo;
- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindDomain:(NSString *)domainName moreComing:(BOOL)moreDomainsComing;
- (void)netServiceBrowser:(NSNetServiceBrowser *) browser didFindService: (NSNetService*) service moreComing: (BOOL)more;
- (void)netServiceBrowser:(NSNetServiceBrowser *) browser didRemoveService: (NSNetService*) service moreComing: (BOOL)more;
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser;
@end