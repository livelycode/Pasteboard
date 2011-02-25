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
  NSURL* url;
}
- (id)initWithURL:(NSURL*)url;
- (id)initWithHost:(NSString*)host port:(NSInteger)port;
- (void)addClient:(CBSyncController*)client;
- (void)syncItem: (CBItem*)item atIndex: (NSInteger)index;
- (NSURL*)URL;
@end
