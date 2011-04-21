//
//  CBDevicesViewControlleriOS.h
//  Cloudboard-iPhone
//
//  Created by Mirko on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBSyncControllerProtocol.h"
@class CBClipboardController, CBSyncController;

@interface CBDevicesViewController : UIViewController {
  @protected
  CBClipboardController* delegate;
  CBSyncController* syncController;
  UITableView* tableView;
  NSMutableArray* foundCloudboards;
  NSMutableArray* selectedCloudboards;
  NSMutableArray* connectedCloudboards;
}
- (void)setSyncController:(CBSyncController*)aSyncController;
- (void)releaseSyncController;
@end

@interface CBDevicesViewController(iOSDelegation)<UITableViewDelegate, UITableViewDataSource, CBSyncControllerProtocol>
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
//CBSyncControllerDelegate
- (void)clientBecameVisible:(NSString*)clientName;
- (void)clientBecameInvisible:(NSString*)clientName;
- (void)clientConnected:(NSString*)clientName;
- (void)clientConfirmed:(NSString*)clientName;
@end