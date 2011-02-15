//
//  SyncController.m
//  cloudboard
//
//  Created by Mirko on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SyncController.h"


@implementation SyncController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    serviceBrowser = [[NSNetServiceBrowser alloc] init];
    [serviceBrowser setDelegate:self];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target: self selector:@selector(searchRemotes:) userInfo:nil repeats: YES];
    return self;
}

- (void) searchRemotes: (NSTimer*) timer {
  if(service != nil) {
    [timer invalidate];
  } else {
    [serviceBrowser stop];
    [serviceBrowser searchForServicesOfType:@"_http._tcp." inDomain:@""];    
  }

}

- (void)dealloc
{
    [super dealloc];
}

@end

@implementation SyncController(Delegation)

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)netServiceBrowser {
  NSLog(@"searching services");
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didNotSearch:(NSDictionary *)errorInfo {
  NSLog(@"did not search services %@", errorInfo);
}

- (void)netServiceBrowser:(NSNetServiceBrowser *) browser didFindService: (NSNetService*) newService moreComing: (BOOL)more; {
  NSLog(@"found service: %@ on port: %i, more coming: %i", newService, [newService port], more);
  if([[newService name] isEqual:@"Cloudboard Server"]) {
    service = newService;
  } else {

  }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *) browser didRemoveService: (NSNetService*) service moreComing: (BOOL)more {
  NSLog(@"removed service: %@", service);
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser {
  NSLog(@"stopped searching");
}
@end