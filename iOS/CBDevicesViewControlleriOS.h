//
//  CBDevicesViewControlleriOS.h
//  Cloudboard-iPhone
//
//  Created by Mirko on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBDevicesViewController.h"

@interface CBDevicesViewController(iOS)
- (void)setSyncController:(CBSyncController*)aSyncController;
- (void)releaseSyncController;
@end

@interface CBDevicesViewController(Delegation)<UITableViewDelegate, UITableViewDataSource, CBSyncControllerProtocol>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
//CBSyncControllerDelegate
- (void)clientBecameVisible:(NSString*)clientName;
- (void)clientBecameInvisible:(NSString*)clientName;
- (void)clientConnected:(NSString*)clientName;
- (void)clientConfirmed:(NSString*)clientName;
@end