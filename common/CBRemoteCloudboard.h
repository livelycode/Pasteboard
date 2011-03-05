//
//  RemoteCloudboard.h
//  cloudboard
//
//  Created by Mirko on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cloudboard.h"

@interface CBRemoteCloudboard : NSObject {
@private
  CBSyncController* syncController;
  NSNetService* service;
  NSURL* url;
  BOOL confirmClient;
  BOOL registerClient;
}
- (id)initWithService:(NSNetService*)service syncController:(CBSyncController*)syncController;
- (void)registerAsClient;
- (void)confirmClient;
- (void)syncItem: (CBItem*)item atIndex: (NSUInteger)index;
- (NSString*)serviceName;
@end

@interface CBRemoteCloudboard(Private)
- (void)resolveService;
- (void)sendRegistration;
- (void)sendRegistrationConfirmation;
@end

@interface CBRemoteCloudboard(Delegation)
//NSNetServiceDelegate
- (void)netServiceDidResolveAddress:(NSNetService *)netService;
- (void)netService:(NSNetService *)netServiceDidNotResolve:(NSDictionary *)errorDict;
@end