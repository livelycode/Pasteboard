//
//  CBSyncControllerProtocol.h
//  Cloudboard-iOS
//
//  Created by Mirko on 3/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cocoa.h"


@protocol CBSyncControllerProtocol <NSObject>

@optional
- (void)clientBecameVisible:(NSString*)clientName;

- (void)clientBecameInvisible:(NSString*)clientName;

- (void)clientConnected:(NSString*)clientName;

- (void)clientRequiresUserConfirmation:(NSString*)clientName;

- (void)clientConfirmed:(NSString*)clientName;

@end